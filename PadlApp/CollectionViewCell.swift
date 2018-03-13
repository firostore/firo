//
//  CollectionViewCell.swift
//  PadlApp
//
//  Created by Jason Tang on 3/7/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    //two variables
    
    @IBOutlet weak var selectionImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var postImage: UIImageView!
    
    var isEditing: Bool = false {
        didSet {
//            selectionImage.isHidden = !isEditing
        }
    }
    
    override var isSelected: Bool {
        didSet {
//            if isEditing {
//                selectionImage.image = isSelected ? UIImage(named: "Checked") : UIImage(named: "Unchecked")
//            }
        }
    }
}
