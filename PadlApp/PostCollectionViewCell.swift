//
//  PostCollectionViewCell.swift
//  PadlApp
//
//  Created by Jason Tang on 3/3/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            image.layer.borderWidth = isSelected ? 10 : 0
        }
    }
    
    // MARK: - View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.borderColor = themeColor.cgColor
        isSelected = false
    }
}
