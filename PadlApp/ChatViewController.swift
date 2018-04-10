//
//  ChatViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 4/1/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    // Declare instance variables here
    var messageArray : [Message] = [Message]()
    var otherUser = ""
    var currentUser = ""
    
    var conversationId = ""
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        messageTextfield.delegate = self
        print("LOADED")
        print(currentUser)
        print(conversationId)
        //TODO: Set the tapGesture here:
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
        messageTableView.addGestureRecognizer(tapGesture)

        //TODO: Register your MessageCell.xib file here:
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "selfMessageCell")
        messageTableView.register(UINib(nibName: "OtherMessageCell", bundle: nil), forCellReuseIdentifier: "otherMessageCell")
        
        retrieveMessages()
        configureTableView()
        
        messageTableView.separatorStyle = .none
        
    }

    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messageArray[indexPath.row].sender == Auth.auth().currentUser?.email {
            let cell = tableView.dequeueReusableCell(withIdentifier: "selfMessageCell", for: indexPath) as! SelfMessageCell
            
            cell.messageBody.text = messageArray[indexPath.row].messageBody
            //        cell.senderUsername.text = messageArray[indexPath.row].sender
            cell.avatarImageView.image = UIImage(named: "profile-placeholder.png")
            
            //        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
            //            cell.avatarImageView.backgroundColor = UIColor.flatMint()
            //            cell.messageBackground.backgroundColor = UIColor.flatGray()
            //        } else {
            //
            //            cell.avatarImageView.backgroundColor = UIColor.flatRed()
            //            cell.messageBackground.backgroundColor = UIColor.flatPlum()
            //        }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "otherMessageCell", for: indexPath) as! OtherMessageCell
            
            cell.messageBody.text = messageArray[indexPath.row].messageBody
            //        cell.senderUsername.text = messageArray[indexPath.row].sender
            cell.avatarImageView.image = UIImage(named: "profile-placeholder.png")
            
            return cell
        }
        
        
    }
    
    //TODO: Declare tableViewTapped here:
    
    func tableViewTapped(){
        
        messageTextfield.endEditing(true)
    }
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = 40
    }
    
    ///////////////////////////////////////////
    
    //MARK:- TextField Delegate Methods
    
    //TODO: Declare textFieldDidBeginEditing here:
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //258+50 = 308 (lets textfield move up with keyboard)
        
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraint.constant = 258
            self.view.layoutIfNeeded()
        })
    }
    
    //TODO: Declare textFieldDidEndEditing here:
    func textFieldDidEndEditing(_ textField: UITextField) {
        //moves textfield back down to the original position
        UIView.animate(withDuration: 0.5, animations: {
            self.heightConstraint.constant = 50
            self.view.layoutIfNeeded()
        })
    }

    

    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase
    
    
    //TODO: Send the message to Firebase and save it in our database
    @IBAction func sendPressed(_ sender: AnyObject) {
        
        messageTextfield.endEditing(true)
        messageTextfield.isEnabled = false
        sendButton.isEnabled = false
        
//        let storage = Storage.storage()
        
        let messagesDB = Database.database().reference().child("Messages/\(currentUser)/\(otherUser)/messages")
        
        let messagesDB2 = Database.database().reference().child("Messages/\(otherUser)/\(currentUser)/messages")
        
        let date_stamp = getTodayString()

        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": messageTextfield.text!, "Time": date_stamp]
        
        messagesDB.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Message saved successfully")
            }
            
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""
            
            
        }
        
        messagesDB2.childByAutoId().setValue(messageDictionary){
            (error, reference) in
            
            if error != nil {
                print(error!)
            } else {
                print("Message saved successfully")
            }
            
            self.messageTextfield.isEnabled = true
            self.sendButton.isEnabled = true
            self.messageTextfield.text = ""
            
            
        }
        
        
        
        
    }
    
    func getTodayString() -> String{
        
        let date = Date()
        
        let calender = Calendar.current
        let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        
        let year = components.year
        let month = components.month
        let day = components.day
        let hour = components.hour
        let minute = components.minute
        let second = components.second
        
        let today_string = String(year!) + "-" + String(month!) + "-" + String(day!) + " " + String(hour!)  + ":" + String(minute!) + ":" +  String(second!)
        
        return today_string
        
    }
    
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        
        let messageDB = Database.database().reference().child("Messages/\(currentUser)/\(otherUser)/messages")
        
        messageDB.observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            let snapshotValue = snapshot.value as! Dictionary<String, String>
            
            let text = snapshotValue["MessageBody"]
            let sender = snapshotValue["Sender"]
            
            let message = Message()
            message.messageBody = text!
            message.sender = sender!
            
            self.messageArray.append(message)
            
            self.configureTableView()
            self.messageTableView.reloadData()
            
        })
        
    }
    
    
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        
        //TODO: Log out the user and send them back to WelcomeViewController
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("error there is a problem")
        }
        
    }
    


}

