//
//  ReviewRowCell.swift
//  AppStoreClone
//
//  Created by Mohammed Hamdi on 2/10/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class ReviewRowCell: UICollectionViewCell {
    
    let ratingsLabel = UILabel(text: "Reviews & Ratings", font: .boldSystemFont(ofSize: 24))
    
    let reviewsController = ReviewsController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(ratingsLabel)
        ratingsLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 20, bottom: 0, right: 20))
        
        addSubview(reviewsController.view)
        reviewsController.view.anchor(top: ratingsLabel.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 12, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
