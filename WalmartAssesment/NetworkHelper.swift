//
//  NetworkHelper.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/27/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import Foundation

class NetworkHelper
{
    //MARK: Static Properties
    
    static let API_Key = "00d0bbb60cabe0eea4939b9922f2b9a5"
    static let PAGE_NUM = 1
    
    static let WALMART_LABS_BASE_URL = "https://api.themoviedb.org/3/search/movie?api_key=00d0bbb60cabe0eea4939b9922f2b9a5&language=en-US&query="
    static var WALMART_LABE_BASE_PATH: String {
        get {
            return self.WALMART_LABS_BASE_URL
        }
    }
    static let POSTER_BASE_URL = "https://image.tmdb.org/t/p/w500"
    static var POSTER_PATH: String{
        get {
            return self.POSTER_BASE_URL
        }
    }
    
}
