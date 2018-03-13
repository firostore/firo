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
        
        performSegue(withIdentifier: "testSegue", sender: self)

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

    override func viewDidLoad() {
        super.viewDidLoad()
        print("called view")
        
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

        let postQuery = PFQuery(className: "Post")
        postQuery.whereKey("userid", equalTo: PFUser.current()?.objectId)
        postQuery.findObjectsInBackground(block: {(objects, error) in
            
            if let posts = objects {
                
                for post in posts {
                    
                    print("ONE POST RETRIEVED")
                    self.images.append(post["imageFile"] as! PFFile)
                    self.sellingCollectionView?.reloadData()
                    
                }
            }
        })
        
        print(self.images)
        
        let width = self.sellingCollectionView?.frame.size.height
        let layout = self.sellingCollectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        //        layout.sectionInset = UIEdgeInsets(top: -40, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: width!, height: width!)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //called anytime a segue is called
        if segue.identifier == "ProfileDetailSegue"{ //passing values over if the segue is the DetailSegue
//            if let dest = segue.destination as? DetailsViewController,
//                let index = sender as? IndexPath {
//                //                        dest.priceValue = prices[index.row]
//                dest.mainImage = images[index.row]
//                dest.titleValue = titles[index.row]
//                dest.userId = usernames[index.row]
//                dest.descriptionValue = descriptions[index.row]
//                
//            }
        }
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
        print("called")
        print("returning a count of: " + "\(images.count)")
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //cellForItemAt (returns cell for index of collectionView
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        if !isEditing {
        //            performSegue(withIdentifier: "DetailSegue", sender: indexPath)
        //        } else {
        //            navigationController?.isToolbarHidden = false
        //        }
        print("touched at: ")
        print(indexPath)
        performSegue(withIdentifier: "ProfileDetailSegue", sender: indexPath)
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
