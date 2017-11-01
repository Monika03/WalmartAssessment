//
//  Movie.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/27/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import UIKit

class Movie: NSObject {

    //MARK: Properties
    
    var voteCount: Int
    var movieId: Int
    var video: Bool
    var voteAverage: Double
    var title: String
    var popularity: Double
    var posterPath: String
    var originalLanguage: String
    var originalTitle: String
    var genreIds:NSArray
    var backdropPath: String
    var adult: Bool
    var overview: String
    var releaseDate:String
    
    var movieImage: UIImage?
    
    
    
    //MARK: Initializer
    
    init?(_ rawDictionary: [String:Any]?) {
        
        guard let dictionary = rawDictionary,
            let voteCount = dictionary["vote_count"] as? Int,
            let movieId = dictionary["id"] as? Int,
            let video = dictionary["video"] as? Bool,
            let voteAverage = dictionary["vote_average"] as? Double,
            let title = dictionary["title"] as? String,
            let popularity = dictionary["popularity"] as? Double,
            let posterPath = dictionary["poster_path"] as? String,
            let originalLanguage = dictionary["original_language"] as? String,
            let originalTitle = dictionary["original_title"] as? String,
            let genreIds = dictionary["genre_ids"] as? NSArray,
            let backdropPath = dictionary["backdrop_path"] as? String,
            let adult = dictionary["adult"] as? Bool,
            let overView = dictionary["overview"] as? String,
            let releaseDate = dictionary["release_date"] as? String
        
            else {
                
                return nil
        }
        
        self.voteCount = voteCount
        self.movieId = movieId
        self.video = video
        self.voteAverage = voteAverage
        self.title = title
        self.popularity = popularity
        self.posterPath = posterPath
        self.backdropPath = backdropPath
        
        let baseString = NetworkHelper.POSTER_BASE_URL
        let pathString = String(format:"%@","\(self.posterPath)")
        let urlString = "\(baseString)\(pathString)"
        self.posterPath  = urlString
        
        let pathString1 = String(format:"%@","\(self.backdropPath)")
        let urlString1 = "\(baseString)\(pathString1)"
        self.backdropPath = urlString1
        
        self.originalLanguage = originalLanguage
        self.originalTitle = originalTitle
        self.genreIds = genreIds
        self.adult = adult
        self.overview = overView
        self.releaseDate = releaseDate
    }
    
    
    
}
