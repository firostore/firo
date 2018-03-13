//
//  ProfileViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 3/4/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate  {

    @IBOutlet weak var profileImage: UIImageView!
    
    
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

        let width = (view.frame.size.width) / 3
        print(width)
        
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
