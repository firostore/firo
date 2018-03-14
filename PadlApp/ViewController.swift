//
//  ViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 2/20/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    var signupModeActive = true
    
    func displayAlert(title:String, message:String) { //creates and displays alert variable.
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            
            self.dismiss(animated: true, completion: nil)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var email: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBAction func signuporLogin(_ sender: Any) {
        
        if email.text == "" || password.text == "" {
            
            self.displayAlert(title: "Error in form", message: "Please enter an email and password")
            
        } else {
             //creates spinner
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            
            activityIndicator.center = self.view.center
            
            activityIndicator.hidesWhenStopped = true
            
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            
            UIApplication.shared.beginIgnoringInteractionEvents()
            //end of spinner code
            
            if (signupModeActive) {
                
                let user = PFUser()
                
                user.username = email.text
                user.password = password.text
                user.email = email.text
                
                
                user.signUpInBackground( block: {(success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if let error = error {
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                        // Show the errorString somewhere and let the user try again.
                    } else {
                        
                        print("signed up!")
                        // Hooray! Let them use the app now.
                        
                        //stores default image for user
                        if let image = UIImage(named: "profile-placeholder.png"){
                            if let imageData = UIImagePNGRepresentation(image) {
                                
                                let imageFile = PFFile(name: "image.png", data: imageData)
                                
                                var profilePicture = PFObject(className: "ProfilePicture")
                                profilePicture["image"] = imageFile
                                profilePicture["user"] = user.objectId
                                profilePicture.saveInBackground {
                                    (success: Bool, error: Error?) in
                                    if (success) {
                                        // The object has been saved.
                                    } else {
                                        // There was a problem, check error.description
                                    }
                                }
                                var wlist = PFObject(className: "WatchList")
                                wlist["user"] = user.objectId
                                wlist["list"] = []
                                wlist.saveInBackground()
                                
                            }
                        }
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                    }
                })
                
            } else {
                PFUser.logInWithUsername(inBackground: email.text!, password: password.text!, block: { (user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil {
                        print("Login succesful")
                        
                        self.performSegue(withIdentifier: "showUserTable", sender: self)
                        
                    } else {
                        
                        var errorText = "Unknown error: please try again."
                        
                        if let error = error {
                            errorText = error.localizedDescription
                            
                        }
                        
                        self.displayAlert(title: "Could not sign you up", message: errorText)
                        
                    }
                    
                    
                })
            }
        }
        
    }
    
    @IBOutlet weak var signupOrLoginButton: UIButton!
    
    @IBAction func switchLoginButton(_ sender: Any) {
        
        if (signupModeActive) {
            
            signupModeActive = false
            
            signupOrLoginButton.setTitle("Log In", for: [])
            
            switchLoginModeButton.setTitle("Sign Up", for: [])
            
        } else {
            
            signupModeActive = true
            
            signupOrLoginButton.setTitle("Sign Up", for: [])
            
            switchLoginModeButton.setTitle("Log In", for: [])
            
            
        }
        
    }
    
    @IBOutlet weak var switchLoginModeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if PFUser.current() != nil {
            self.performSegue(withIdentifier: "showUserTable", sender: self)
        }
        
        self.navigationController?.navigationBar.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

