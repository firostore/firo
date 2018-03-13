//
//  DetailsViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 3/7/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse

class DetailsViewController: UIViewController {
    
    var titleValue: String!
    var descriptionValue: String!
    var priceValue: Float!
    var userId: String!
    var mainImage: PFFile!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var userView: UIImageView!
    @IBOutlet weak var userText: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = titleValue
        descriptionText.text = descriptionValue
        price.text = "\(priceValue)"
        
        mainImage.getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData){
                    
                    self.imageView.image = imageToDisplay
                    
                }
            }
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
