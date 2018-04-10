//
//  ConversationPreviewCell.swift
//  PadlApp
//
//  Created by Jason Tang on 4/1/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit

class ConversationPreviewCell: UITableViewCell {
    //identifier: conversationCell
    
    @IBOutlet weak var lastMessage: UILabel!
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImage.setRounded()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}
