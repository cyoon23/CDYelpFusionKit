//
//  CDYelpOAuthManager.swift
//  Pods
//
//  Created by Christopher de Haan on 11/7/16.
//
//  Copyright (c) 2016 Christopher de Haan <contact@christopherdehaan.me>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Alamofire
import AlamofireObjectMapper

public class CDYelpOAuthAPIClient: NSObject {
    
    fileprivate let clientId: String
    fileprivate let clientSecret: String
    
    var oAuthCredential: CDYelpOAuthCredential? = nil
    
    public init(clientId: String!,
                clientSecret: String!) {
        assert((clientId != nil && clientId != "") &&
            (clientSecret != nil && clientSecret != ""), "Both a clientId and clientSecret are required to query the Yelp Fusion V3 Developers API oauth endpoint.")
        
        self.clientId = clientId
        self.clientSecret = clientSecret
    }
    
    public func authorize(completion: @escaping (Bool?, Error?) -> Void) {
        let params: Parameters = ["grant_type": "client_credentials",
                                  "client_id": self.clientId,
                                  "client_secret": self.clientSecret]
        Alamofire.request(CDYelpOAuthRouter.authorize(parameters: params)).responseObject { (response: DataResponse<CDYelpOAuthCredential>) in
            switch response.result {
            case .success(let oAuthCredential):
                self.oAuthCredential = oAuthCredential
                completion(true, nil)
                break
            case .failure(let error):
                print("authorize() failure: ", error.localizedDescription)
                completion(false, error)
                break
            }
        }
    }
}
