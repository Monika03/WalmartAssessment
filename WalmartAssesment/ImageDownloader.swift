//
//  ImageDownloader.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/29/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import Foundation
import UIKit

/// @brief `CompletionBlock` to be called on main queue upon completion.
typealias CompletionBlock = (_ error: Error?, _ image: UIImage?) -> Void

/// @brief `ImageDownloader` class provides convenience methods to download images from URL.
class ImageDownloader {
    
    var movie:Movie?
    lazy var movieService: WalmartMovieService = WalmartMovieServiceImpl()
    
    //MARK: Private Properties
    private var downloadTask: URLSessionDataTask?
    private let kImageSize: CGFloat = 100.0
    
    //MARK: Initializer
    init(_ movie: Movie) {
        
        self.movie = movie
    }
    
    //MARK: Instance methods
    
    /// @brief Use this method to start product image download for a given product model object
    ///
    /// - Parameter completionHandler: The completionBlock to be called on main queue
    func startDownload(_ completionHandler: @escaping CompletionBlock) {
        
        if let movie = self.movie {           
            self.downloadTask = self.movieService.downloadImage(movie.posterPath, httpMethod: .Get, completionHandler: { [weak self](error, data) in
                
                guard let data = data, error == nil else {
                    
                    if let err = error {
                        NSLog(err.localizedDescription)
                    }
                    
                    completionHandler(error, nil)
                    return
                }
                
                OperationQueue.main.addOperation({
                    
                    var downloadedImage: UIImage? = nil
                    
                    if let image = UIImage(data: data),
                        let imageSize = self?.kImageSize, (image.size.width != imageSize || image.size.height != imageSize) {
                        
                        let imageSize = CGSize(width: imageSize, height: imageSize)
                        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
                        let rect = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
                        image.draw(in: rect)
                        downloadedImage = UIGraphicsGetImageFromCurrentImageContext()
                        self?.movie?.movieImage = downloadedImage
                        UIGraphicsEndImageContext()
                    }
                    else {
                        downloadedImage = UIImage(data: data)
                        self?.movie?.movieImage = downloadedImage
                    }
                    
                    completionHandler(nil, downloadedImage)
                })
            })
        }
    }
    
    /// @brief Use this method to cancel current on going download.
    func cancelDownload() {
        
        if let task = self.downloadTask {
            task.cancel()
        }
        self.downloadTask = nil
    }
    
}


