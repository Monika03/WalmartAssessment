//
//  WalmartMovieService.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/27/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import Foundation
import UIKit

/// @brief `ProductFetchCompletionBlock` to be called on main queue upon completion of fetching products info from url.
typealias MovieFetchCompletionBlock = (_ error: Error?, _ movies: [Movie]?) -> Void


/// @brief `ImageDownloaderCompletionBlock` to be called on main queue upon completion of downloading the image from url.
typealias ImageDownloaderCompletionBlock = (_ error: Error?, _ data: Data?) -> Void


/// @brief `WalmartProductService` provides convenience methods to handle product info fetch and image download.
protocol WalmartMovieService {
    
    /// @brief Use this method to fetch products info.
    ///
    /// - Parameters:
    ///   - url: The url to fetch the products info from.
    ///   - completionHandler: The block to be called on main queue upon completion
    /// - Returns: The array of products in case of success, or error in case of failure.
    func fetchProductsInfo(_ url: String, completionHandler: @escaping MovieFetchCompletionBlock)
    
    
    /// @brief Use this method to download image from url.
    ///
    /// - Parameters:
    ///   - url: The url to download image from
    ///   - httpMethod: The http method type
    ///   - completionHandler: The block to be called on main queue upon completion
    /// - Returns: The raw image data in case of success, or error in case of failure.
    func downloadImage(_ url: String, httpMethod: RESTMethodType, completionHandler: @escaping ImageDownloaderCompletionBlock) -> URLSessionDataTask?
}

