//
//  BaseRESTService.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/27/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import Foundation

// @brief `BaseServiceCompletionBlock` to be called on main queue upon completion.
typealias BaseServiceCompletionBlock = (_ error: Error?, _ parsedJson: [String: Any]?, _ statusCode: Int) -> Void

/// @brief `RESTMethodType` is an enum for all supported HTTPMethod types
///
/// - Get: Maps to HTTP GET method.
enum RESTMethodType: String {
    
    case Get = "GET"
}

/// @brief `BaseRESTService` protocol defines convenience methods to handle REST requests.
protocol BaseRESTService {
    
    func sendRequest(_ url: String, httpMethod: RESTMethodType, body: [String: Any]?, completionBlock: @escaping BaseServiceCompletionBlock)
}

/// @brief `BaseRESTServiceImpl` class implements methods defined in `BaseRESTService` to handle REST Requests
class BaseRESTServiceImpl: BaseRESTService {
    
    func sendRequest(_ url: String, httpMethod: RESTMethodType, body: [String : Any]?, completionBlock: @escaping BaseServiceCompletionBlock) {
        
        if let requestURL = URL(string: url) {
            var request = URLRequest(url: requestURL)
            request.httpMethod = httpMethod.rawValue
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                guard let data = data, error == nil else {
                    completionBlock(error, nil, 500)
                    return
                }
                
                var err: NSError? = nil
                if let httpResponse = response as? HTTPURLResponse {
                    var json:[String: Any]? = nil
                    if (httpResponse.statusCode == 200 || httpResponse.statusCode == 204) {
                        if (httpResponse.statusCode == 200) {
                            do {
                                json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String : Any]
                            } catch {
                                err = NSError(domain: NSLocalizedString("JSON_PARSING_ERROR_DOMAIN", comment: "Error Domain"), code: 500, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("JSON_PARSING_ERROR_MESSAGE", comment: "Error Message")])
                                print(err!)
                            }
                        }
                    } else {
                        let message = String(data: data, encoding: .utf8)
                        if let message = message {
                            err = NSError(domain: NSLocalizedString("SERVER_ERROR", comment: "Server Error"), code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: message])
                        } else {
                            err = NSError(domain: NSLocalizedString("SERVER_ERROR", comment: "Server Error"), code: httpResponse.statusCode)
                        }
                        
                        print(err!)
                    }
                    
                    completionBlock(err, json, httpResponse.statusCode)
                    return
                }
                
                completionBlock(err, nil, 500)
            })
            
            task.resume()
        }
    }
}

