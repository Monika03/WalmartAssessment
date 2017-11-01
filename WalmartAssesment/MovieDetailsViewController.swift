//
//  MovieDetailsViewController.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/31/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    var movie: Movie?
  
    
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    @IBOutlet weak var releaseDate: UILabel!
    
    @IBOutlet weak var averageRating: AverageVoting!
    
    @IBOutlet weak var audltLabel: UILabel!
    @IBOutlet weak var movieLanguage: UILabel!
    @IBOutlet weak var movieOverview: UILabel!
    @IBOutlet weak var voteCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavigationBar()
        self.configureLabels()
    }
    
    private func configureNavigationBar() {
        
        self.title = NSLocalizedString("MOVIE DETAILS", comment: "")
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    private func configureLabels(){
        
        let selectedMovie = movie
        
        self.movieName.text = selectedMovie?.originalTitle
        self.averageRating.widthAnchor.constraint(equalToConstant: 240.0).isActive = true
        self.averageRating.starImageSize = 24.0
        self.averageRating.rating = Float((selectedMovie?.voteAverage)!)
        self.releaseDate.text = selectedMovie?.releaseDate
        self.movieOverview.text = selectedMovie?.overview
        self.moviePoster.image = selectedMovie?.movieImage
        
        if(selectedMovie?.originalLanguage == "en")
        {
          self.movieLanguage.text = NSLocalizedString("ENGLISH", comment: "")
        }else
        {
          self.movieLanguage.text = NSLocalizedString("CHINESE", comment: "")
        }
        
        self.audltLabel.text = (selectedMovie?.adult)! ? NSLocalizedString("PG", comment: ""): NSLocalizedString("G", comment: "")
        self.voteCount.text = String(format: NSLocalizedString("%@", comment: ""), "\(selectedMovie!.voteCount)")
    }
    

    
}
