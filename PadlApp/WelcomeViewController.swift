//
//  WelcomeViewController.swift
//  Messaging Portion
//
//  This is the welcome view controller - the first thign the user sees
//

import UIKit
import Firebase



class WelcomeViewController: UIViewController {

    @IBAction func registerButton(_ sender: Any) {
//        self.performSegue(withIdentifier: "showRegister", sender: self)
    }
    
    @IBAction func loginButton(_ sender: Any) {
//        self.performSegue(withIdentifier: "showLogIn", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser != nil {
            // User is signed in.
            performSegue(withIdentifier: "directMessage", sender: self)
        } else {
            // No user is signed in.
            // ...
        }
        self.navigationController?.isNavigationBarHidden = true
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
