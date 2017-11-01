//
//  WalmartMovieServiceImpl.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/27/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import Foundation

class WalmartMovieServiceImpl: WalmartMovieService{
    
    lazy var baseService: BaseRESTService = BaseRESTServiceImpl()
    
    func fetchProductsInfo(_ url: String, completionHandler: @escaping MovieFetchCompletionBlock) {
        
        self.baseService.sendRequest(url, httpMethod: .Get, body: nil) { (error, json, statusCode) in
            
            if let err = error {
                completionHandler(err, nil)
                return
            }
            
            if (statusCode != 200) {
                
                let error = NSError(domain: "Error: Unable to retrieve products info", code: statusCode, userInfo: nil)
                completionHandler(error, nil)
                return
            }
            
            var movies = [Movie]()
            if let response = json,
                let rawProducts = response["results"] as? [[String:Any]] {
                for dictionary in rawProducts {
                    if let movie = Movie(dictionary) {
                        movies.append(movie)
                    }
                }
            }
            
            completionHandler(nil, movies)
        }
    }
    
    func downloadImage(_ url: String, httpMethod: RESTMethodType, completionHandler: @escaping ImageDownloaderCompletionBlock) -> URLSessionDataTask? {
        
        if let requestURL = URL(string: url) {
            
            var request = URLRequest(url: requestURL)
            request.httpMethod = httpMethod.rawValue
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                guard let data = data, error == nil else {
                    completionHandler(error, nil)
                    return
                }
                
                completionHandler(nil, data)
            })
            
            task.resume()
            return task
        }
        
        return nil
    }
    
}
