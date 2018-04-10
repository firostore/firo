//
//  DetailsViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 3/7/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse
import Firebase

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
    var currentUser = ""
    
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

    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var watchButton: UIButton!
    
    var watchList = [String]()
    var inWatchList: Bool!
    var usersPost: Bool! //If true, the post is the users and the delete button must be displayed
    
    @IBAction func deleteItem(_ sender: Any) {
        
        var query = PFQuery(className:"WatchList") //Query to edit the watchlist
        query.findObjectsInBackground(block: { (objects, error) in
            if error == nil {
                // The find succeeded.
                for object in objects! {
                    print("newone", object["list"])
                    if self.post.objectId == object["list"] as? String {
                        var new_list = object["list"] as? [String]
                        object["list"] = new_list!.filter() { $0 != self.post.objectId }
                        object.saveInBackground()
//                        object["list"] = list["list"].filter() { $0 !== self.post.objectId }
//                        print("yo")
                    }
                    print(object["list"])
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        })
        
        post.deleteInBackground()

        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func addToWatchList(_ sender: Any) {
        
        var query = PFQuery(className:"WatchList") //Query to edit the watchlist
        query.whereKey("user", equalTo:PFUser.current()?.objectId)
        query.getFirstObjectInBackground(block: { (object, error) in
            if error == nil {
                // The find succeeded.
                if let wl = object {
                    print("addingggg")
                    
                    print(self.inWatchList)
                    self.watchList = wl["list"] as! [String]
                    if !self.inWatchList {
                        if(!self.watchList.contains(self.post.objectId!)){ //double checks if the user is already watching this post
                            self.watchList.append(self.post.objectId!)
                            self.watchButton.setTitle("Remove from watchlist", for: [])
                            self.inWatchList = true
                        }
                    } else {
//                        print
//                        ("")
                        self.watchList = self.watchList.filter() { $0 != self.post.objectId }
                        self.watchButton.setTitle("Add to Watch List", for: [])
                        self.inWatchList = false
                    }
//                    self.watchButton.setTitle("Remove from watchlist", for: [])
//                    self.view.setNeedsLayout() //updates view


                    wl["list"] = self.watchList
                    wl.saveInBackground()
                }
            } else {
                // Log details of the failure
                print("Error: \(error!)")
            }
        })

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.inWatchList = false
        
        let watchPostQuery = PFQuery(className: "WatchList") //Retrieves the watch list and updates watch arrays with respective values
        watchPostQuery.whereKey("user", equalTo: PFUser.current()?.objectId)
        watchPostQuery.getFirstObjectInBackground(block: {(object, error) in
            
            if let watchlist = object {
                
                if (watchlist["list"] as! [String]).contains((self.post.objectId)!) {
                    self.watchButton.setTitle("Remove from watchlist", for: [])
                    self.inWatchList = true
                    print("already on waitlists")
                }
                print(self.inWatchList)
                
                
            }
        })
        if self.post["userid"] as! String == PFUser.current()?.objectId {
            deleteButton.isHidden = false
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //called anytime a segue is called
        

        if segue.identifier == "createMessage"{
            
            print(segue.destination)
            if let dest = segue.destination as? ChatViewController{
                
//                let messageDB = Database.database().reference().child("Messages/\(currentUser)")
//                
//                messageDB.observeSingleEvent(of: .value, with: { (snapshot) in
//                    print(self.userText.text!)
//                    if snapshot.hasChild(self.userText.text!){
                
                        dest.otherUser = self.userText.text!
                        dest.currentUser = (Auth.auth().currentUser?.uid)!
                        
//                    }else{
//
//                        messages.child(self.userText.text!).child("messages")
//                    }
//
//
//                })
                
//                dest.conversationId = conversationIds[index.row]
                
            }
        }
    }
    
    @IBAction func contactSeller(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "createMessage", sender: self)
        } else {
            //User Not logged in
            print("not logged in") //perform login segue
        }
    }
    @IBAction func contactUser(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            performSegue(withIdentifier: "MessageDetail", sender: self)
        } else {
            //User Not logged in
            print("not logged in") //perform login segue
        }
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
