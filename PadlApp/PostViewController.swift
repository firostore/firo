//
//  PostViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 2/21/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse
import QuartzCore

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var postButton: UIButton!

    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var postTitle: UITextField!

    @IBOutlet weak var postDescription: UITextView!
    
    func displayAlert(title:String, message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func chooseImage(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageToPost.image = image
            
        } else {
            print("something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postImage(_ sender: Any) {
        
        if let image = imageToPost.image {
            
            //Creates activity spinner for user
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            //ends spinner code
            let post = PFObject(className: "Post")
            
            post["title"] = postTitle.text
            
            post["description"] = postDescription.text
            
            post["userid"] = PFUser.current()?.objectId
            
            if let imageData = UIImagePNGRepresentation(image) {
                
                let imageFile = PFFile(name: "image.png", data: imageData)
                
                post["imageFile"] = imageFile
                
                post.saveInBackground(block: { (success, error) in
                    
                    if success {
                        
                        self.displayAlert(title: "Congratulations!", message: "Your post has been listed succesfully.")
                        
                        self.postDescription.text = ""
                        
                        self.postTitle.text = ""
                        
                        self.imageToPost.image = nil
                        
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                    } else {
                        
                        self.displayAlert(title: "Your post could not be listed", message: "Please try again")
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        
                    }
                    
                })
            }
            
        }
        
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        postDescription.layer.borderColor = UIColor.gray.cgColor
        postDescription.layer.borderWidth = 1.0
        postDescription.layer.cornerRadius = 5
        
        postTitle.layer.borderColor = UIColor.gray.cgColor
        postTitle.layer.borderWidth = 1.0
        postTitle.layer.cornerRadius = 5
        
        

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
