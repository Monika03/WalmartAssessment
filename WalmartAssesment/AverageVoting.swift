//
//  AverageVoting.swift
//  WalmartAssesment
//
//  Created by Ankam Mounika on 10/31/17.
//  Copyright © 2017 Ankam Mounika. All rights reserved.
//

import UIKit

class AverageVoting: UIStackView {

    //MARK: Variables
    var starImageSize: CGFloat = 0.0
    
    var rating: Float = 0.0 {
        didSet {
            setupStars()
        }
    }
    
    //MARK: Private Variables
    private let MAX_STARS = 10
    
    //MARK: Instance Methods
    private func setupStars() {
        
        self.reset()
        
        for index in 0..<self.MAX_STARS {
            
            let imageView = UIImageView()
            imageView.image = UIImage(named: "EmptyStar_24")
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.heightAnchor.constraint(equalToConstant: self.starImageSize).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: self.starImageSize).isActive = true
            addArrangedSubview(imageView)
            
            if (self.rating >= Float(index + 1)) {
                
                imageView.image = UIImage(named: "FullStar_24")
            } else if (self.rating > Float(index)) {
                
                imageView.image = UIImage(named: "HalfStar_24")
            }
        }
    }
    
    func reset() {
        
        for view in self.subviews {
            self.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }


}
