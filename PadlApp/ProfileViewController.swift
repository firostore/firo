 //
//  ProfileViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 3/4/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse

private let reuseIdentifier = "SellCell"

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var buyingCollectionView: UICollectionView!
    
    @IBOutlet weak var sellingCollectionView: UICollectionView!
    
    @IBAction func contactButton(_ sender: Any) {
    }
    @IBAction func changePassword(_ sender: Any) {

    }
    
    @IBAction func logoutUser(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)
        
        
    }
    
    @IBAction func changeProfile(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            profileImage.image = image
                
            //Creates activity spinner for user
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            //ends spinner code
            let query = PFQuery(className:"ProfilePicture")
            query.whereKey("user", equalTo: PFUser.current()?.objectId)
            query.getFirstObjectInBackground(block: { (object, error) in
                if let profile = object {
                    if profile["image"] != nil{
                        if let imageData = UIImagePNGRepresentation(image) {
                            
                            let imageFile = PFFile(name: "image.png", data: imageData)
                            
                            profile["image"] = imageFile
                            
                            profile.saveInBackground()
                            
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                        
                    } else {
                        
                    }
                    
                }
                
            })


            
        } else {
            print("something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    var images = [PFFile]()
    var sellingPosts = [PFObject]()
    
    var watchList = [String]() //list of post.objectIds that are on the users watch list
    var watchingImages = [PFFile]()
    var watchingPosts = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let sellWidth = self.sellingCollectionView?.frame.size.height //creates layout for sellingCollectionView
        let sellLayout = self.sellingCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        //        layout.sectionInset = UIEdgeInsets(top: -40, left: 0, bottom: 10, right: 0)
        sellLayout.itemSize = CGSize(width: sellWidth!, height: sellWidth!)
        sellLayout.minimumInteritemSpacing = 2
        sellLayout.minimumLineSpacing = 2

        
        let buyWidth = self.buyingCollectionView?.frame.size.height //creates layout for buyingCollectionView
        let buyLayout = self.buyingCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        //        layout.sectionInset = UIEdgeInsets(top: -40, left: 0, bottom: 10, right: 0)
        buyLayout.itemSize = CGSize(width: buyWidth!, height: buyWidth!)
        buyLayout.minimumInteritemSpacing = 2
        buyLayout.minimumLineSpacing = 2
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        print("new view")
        //sets all variables to zero before assinging more
        self.watchList = []
        self.watchingImages = []
        self.watchingPosts = []
        self.sellingPosts = []
        self.images = []
        
        let query = PFQuery(className:"ProfilePicture")
        query.whereKey("user", equalTo: PFUser.current()?.objectId)
        query.getFirstObjectInBackground(block: { (object, error) in
            if let profile = object {
                if profile["image"] != nil{
                    
                    let userImage = profile["image"] as! PFFile
                    userImage.getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData){
                                
                                self.profileImage.image = imageToDisplay
                                
                            }
                        }
                    }
                    
                } else {
                    
                }
                
            }
            
        })
        
        let postQuery = PFQuery(className: "Post") //retrieves all posts of the user (everything he is selling)
        postQuery.whereKey("userid", equalTo: PFUser.current()?.objectId)
        postQuery.findObjectsInBackground(block: {(objects, error) in
            
            if let posts = objects {
                
                for post in posts {
                    
                    self.sellingPosts.append(post as! PFObject)
                    self.images.append(post["imageFile"] as! PFFile)
                    self.sellingCollectionView?.reloadData()
                    
                }
            }
        })
        
        let watchPostQuery = PFQuery(className: "WatchList") //Retrieves the watch list and updates watch arrays with respective values
        watchPostQuery.whereKey("user", equalTo: PFUser.current()?.objectId)
        watchPostQuery.getFirstObjectInBackground(block: {(object, error) in
            
            if let watchlist = object {
                
                self.watchList = watchlist["list"] as! [String]
                
                let watchImagesQuery = PFQuery(className: "Post")
                
                watchImagesQuery.whereKey("objectId", containedIn: self.watchList) //adds each element of watchlist to the arrays
                watchImagesQuery.findObjectsInBackground(block: {(objects, error) in
                    
                    if let posts = objects {
                        
                        for post in posts {
                            
                            self.watchingPosts.append(post as! PFObject)
                            self.watchingImages.append(post["imageFile"] as! PFFile)
                            self.buyingCollectionView?.reloadData()
                            
                        }
                    }
                })
            }
            
        })
        print(self.images)
        print(self.sellingPosts)
        print(self.watchingPosts)
        
        self.sellingCollectionView?.reloadData()
        self.buyingCollectionView?.reloadData()
        print("rlaoded")
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //called anytime a segue is called
        print(segue.identifier)
        if segue.identifier == "ProfileDetailsSegue"{ //passing values over if the segue is the DetailSegue
            print("right track")
            print(segue.destination)
            if let dest = segue.destination as? DetailsViewController,
                let index = sender as? IndexPath {
                print("ypppp", images[index.row])
                dest.mainImage = images[index.row]
                dest.post = sellingPosts[index.row]
                
            }
            print("da fuck")
        } else if segue.identifier == "ProfileWatchingSegue"{ //passing values over if the segue is the DetailSegue
            if let dest = segue.destination as? DetailsViewController,
                let index = sender as? IndexPath {
                //                        dest.priceValue = prices[index.row]
                dest.post = watchingPosts[index.row]
                //                        dest.titleValue = titles[index.row]
                dest.mainImage = watchingImages[index.row]
                //                        dest.descriptionValue = descriptions[index.row]
                //                        dest.priceValue = prices[index.row]
                //                        dest.userId = usernames[index.row]
                
            }
        }
//        else if segue.identifier == "EditPostSegue"{ //passing values over if the segue is the DetailSegue
//            if let dest = segue.destination as? DetailsViewController,
//                let index = sender as? IndexPath {
//                
//                dest.post = sellingPosts[index.row]
//                
//                dest.mainImage = images[index.row]
//                
//                
//            }
//        }
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //numberOfItemsInSection (returns number of rows)
        print("reloading views at core")
        if collectionView == self.sellingCollectionView {
            return images.count
        } else {
            return watchList.count
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //cellForItemAt (returns cell for index of collectionView
        if collectionView == self.sellingCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SellCell", for: indexPath) as! ProfileCollectionViewCell
            
            images[indexPath.row].getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData){
                        print(imageToDisplay)
                        cell.postImage.image = imageToDisplay
                        
                    }
                }
            }
            
            //        cell.titleLabel.text = collectionData[indexPath.row]
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BuyCell", for: indexPath) as! ProfileCollectionViewCell
            
            print(indexPath.row)
            print(watchingImages[indexPath.row])
            watchingImages[indexPath.row].getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData){
                        print(imageToDisplay)
                        cell.postImage.image = imageToDisplay
                        
                    }
                }
            }
            
            //        cell.titleLabel.text = collectionData[indexPath.row]
            
            return cell
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if !isEditing {
        //            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        //        } else {
        //            navigationController?.isToolbarHidden = false
        //        }

        if collectionView == sellingCollectionView {
            performSegue(withIdentifier: "ProfileDetailsSegue", sender: indexPath)
        } else {
            performSegue(withIdentifier: "ProfileWatchingSegue", sender: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        //        if isEditing {
        //            if let selected = collectionView.indexPathsForSelectedItems,
        //                selected.count == 0 {
        //                navigationController?.isToolbarHidden = true
        //            }
        //        }
    }


}
