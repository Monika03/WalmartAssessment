//
//  MovieTableViewCell.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/29/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    
    func configureCellWithMovie(_movie: Movie)
    {
       self.movieName.text = _movie.originalTitle
       self.movieLanguage.text = _movie.originalLanguage
       self.releaseDate.text = String(format: NSLocalizedString("Release Date: %@", comment: ""), "\(_movie.releaseDate)")
        
        if(_movie.originalLanguage == "en")
        {
            self.movieLanguage.text = NSLocalizedString("ORIGINAL LANGUAGE(S): ENGLISH", comment: "")
        }else
        {
            self.movieLanguage.text = NSLocalizedString("ORIGINAL LANGUAGE(S): CHINESE", comment: "")
        }        
    }
    
    override func prepareForReuse() {
        self.movieLanguage.text = ""
        self.movieName.text = ""
        self.releaseDate.text = ""
    }
}
