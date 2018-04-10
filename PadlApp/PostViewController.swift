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
import FirebaseStorage
//import ImagePicker
//import Lightbox

class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, UITextViewDelegate {
    
    
    @IBOutlet weak var postButton: UIButton!

    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var postTitle: UITextField!

    @IBOutlet weak var postDescription: UITextView!
    
    @IBOutlet weak var acceptsOffers: UISwitch!
    @IBOutlet weak var priceField: UITextField!
    var condition: String!
    var location: String!
    var category: String!
    
    @IBOutlet weak var conditionLabel: UILabel!

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBAction func unwindSegue(_ sender: UIStoryboardSegue) {
        
    }

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
//        let imagePicker = ImagePickerController(configuration: config)
//        imagePicker.delegate = self
//
//        present(imagePicker, animated: true, completion: nil)
//    }
//
//    // MARK: - ImagePickerDelegate
//
//    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//
//    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        guard images.count > 0 else { return }
//
//        let lightboxImages = images.map {
//            return LightboxImage(image: $0)
//        }
//
//        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
//        imagePicker.present(lightbox, animated: true, completion: nil)
//    }
//
//    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
//        imagePicker.dismiss(animated: true, completion: nil)
//    }
//
    
    
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
            
            post["price"] = priceField.text
            
            post["userid"] = PFUser.current()?.objectId
            
            post["condition"] = conditionLabel.text
            
            post["category"] = categoryLabel.text
            
            post["location"] = locationLabel.text
            
            post["offers"] = acceptsOffers.isOn
            
            let storageRef = Storage.storage().reference(withPath: "postPictures/post1.jpg")
            let uploadMeta = StorageMetadata()
            uploadMeta.contentType = "image/jpeg"
            
            if let imageData = UIImageJPEGRepresentation(image, 0.8) {
            
                storageRef.putData(imageData, metadata: uploadMeta) { (metadata, error) in
                    
                    if (error != nil) {
                        print("ERROR")
                    } else {
                        print("SUCESS here's url: \(String(describing: metadata?.downloadURL()))")
                        
                    }
                }
            }
            
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //called anytime a segue is called
        if segue.identifier == "showCondition"{ //passing values over if the segue is the DetailSegue
            if let dest = segue.destination as? PostDetailTableViewController,
                let id = sender as? Int {
                //                        dest.priceValue = prices[index.row]
                if id == 1 {
                    dest.typeId = 1
                } else if id == 2 {
                    dest.typeId = 2
                } else if id == 3{
                    dest.typeId = 3
                }
                
            }
        }
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.isNavigationBarHidden = true
//        postDescription.layer.borderColor = UIColor.gray.cgColor
//        postDescription.layer.borderWidth = 1.0
        
//        postButton.layer.borderColor = UIColor.gray.cgColor
//        postButton.layer.borderWidth = 5.0
//        postButton.layer.cornerRadius = 10.0
        let blueSky = UIColor(red: 255, green: 104, blue: 159, alpha: 0.1)
        postButton.setBackgroundColor(color: blueSky, forState: .highlighted)
//        self.donateButton.setTitleColor(UIColor.whiteColor(), forState: .Highlighted)
        
//        postButton.layer.shadowColor = UIColor.black.cgColor
//        postButton.layer.shadowOffset = CGSize(width: 5, height: 5)
//        postButton.layer.shadowRadius = 5
//        postButton.layer.shadowOpacity = 0.3
//        postDescription.layer.cornerRadius = 5
//
//        postTitle.layer.borderColor = UIColor.gray.cgColor
//        postTitle.layer.borderWidth = 3.0
//        postTitle.layer.cornerRadius = 5
        
        let tapCondition = UITapGestureRecognizer(target: self, action: #selector(PostViewController.chooseCondition))
        let tapCategory = UITapGestureRecognizer(target: self, action: #selector(PostViewController.chooseCategory))
        let tapLocation = UITapGestureRecognizer(target: self, action: #selector(PostViewController.chooseLocation))
        
        conditionLabel.addGestureRecognizer(tapCondition)
        categoryLabel.addGestureRecognizer(tapCategory)
        locationLabel.addGestureRecognizer(tapLocation)
        
        //sets textfield delegate to self
        postTitle.delegate = self
        
        //lets textfield resize according to content
//        postDescription.translatesAutoresizingMaskIntoConstraints = true
//        postDescription.sizeToFit()
//        postDescription.isScrollEnabled = false
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PostViewController.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if condition != nil {
            conditionLabel.text = condition
        }
        if category != nil {
            categoryLabel.text = category
        }
        if location != nil {
            locationLabel.text = location
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    var tableId: Int!
    
    func chooseCondition(sender:UITapGestureRecognizer) {
        tableId = 1
        performSegue(withIdentifier: "showCondition", sender: tableId)
    }
    
    func chooseCategory(sender:UITapGestureRecognizer) {
        tableId = 2
        performSegue(withIdentifier: "showCondition", sender: tableId)
    }
    
    func chooseLocation(sender:UITapGestureRecognizer) {
        tableId = 3
        performSegue(withIdentifier: "showCondition", sender: tableId)
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

extension UIButton {
    
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, for: forState)
    }
}

