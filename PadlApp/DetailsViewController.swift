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
    
//    var titleValue: String!
    var mainImage: PFFile!
//    var descriptionValue: String!
//    var priceValue: Float!
//    var userImage: PFFile!
//    var userId: String!
//    
//    var acceptOffer: Bool!
//    var categoryValue: String!
//    var conditionValue: String!
//    var locationValue: String!
    
    var post = PFObject(className: "Post")

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var userView: UIImageView!
    @IBOutlet weak var userText: UILabel!
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    var watchList = [String]()
    
    @IBAction func addToWatchList(_ sender: Any) {

        var query = PFQuery(className:"WatchList") //Query to edit the watchlist
        query.whereKey("user", equalTo:PFUser.current()?.objectId)
        query.getFirstObjectInBackground(block: { (object, error) in
            if error == nil {
                // The find succeeded.
                if let wl = object {
                    self.watchList = wl["list"] as! [String]
                    print(self.post)
                    if(!self.watchList.contains(self.post.objectId!)){ //double checks if the user is already watching this post
                        self.watchList.append(self.post.objectId!)
                    }

                    wl["list"] = self.watchList
                    wl.saveInBackground()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        })

    }
    
    @IBAction func contactSeller(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = self.post["title"] as! String?
        descriptionText.text = self.post["description"] as! String!
        price.text = "\(post["price"])"
        userText.text = post["userid"] as! String!
        if post["offers"] as! Bool == true {
            offerLabel.text = "Yes"
        } else {
            offerLabel.text = "No"
        }
        categoryLabel.text = post["category"] as! String?
        conditionLabel.text = post["condition"] as! String?
        locationLabel.text = post["location"] as! String?
        
        
        mainImage.getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData){
                    
                    self.imageView.image = imageToDisplay
                    
                }
            }
        }
        
        let query = PFQuery(className:"ProfilePicture")
        query.whereKey("user", equalTo: post["userid"] as! String?)
        query.getFirstObjectInBackground(block: { (object, error) in
            if let profile = object {
                if profile["image"] != nil{
                    
                    let userImage = profile["image"] as! PFFile
                    userImage.getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData){
                                
                                self.userView.image = imageToDisplay
                                
                            }
                        }
                    }
                    
                } else {
                    
                }
                
            }
            
        })
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
