//
//  ChatListViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 4/1/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import ChameleonFramework

class ChatListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Declare instance variables here
    var conversationUsers : [String] = [String]()
    var conversationIds : [String] = [String]()

    @IBOutlet var messageTableView: UITableView!
    
    var currentUser : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        
        //TODO: Set the tapGesture here:
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tableViewTapped))
//        messageTableView.addGestureRecognizer(tapGesture)
        
        self.navigationController?.isNavigationBarHidden = false

//        self.navigationItem.hidesBackButton = true
//
        self.navigationController?.navigationBar.tintColor = UIColor.white

        currentUser = Auth.auth().currentUser?.uid as! String
        
        retrieveMessages()
        configureTableView()
        
        messageTableView.separatorStyle = .none
        
        let messagesDB = Database.database().reference().child("Messages/\(currentUser as! String)")
        
//        let messageDictionary = ["Sender": Auth.auth().currentUser?.email, "MessageBody": "Gay"]
        
//        let messageDictionary = "my value"
//        messagesDB.child(currentUser).setValue(messageDictionary){
//            (error, reference) in
//
//            if error != nil {
//                print(error!)
//            } else {
//                print("Message saved successfully")
//            }
//        }
        
    }
    
    ///////////////////////////////////////////
    
    //MARK: - TableView DataSource Methods

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return conversationUsers.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "conversationCell", for: indexPath) as! ConversationPreviewCell
        
        cell.userTitle.text = conversationUsers[indexPath.row]
        //        cell.senderUsername.text = messageArray[indexPath.row].sender
        cell.userImage.image = UIImage(named: "profile-placeholder.png")
        
        cell.lastMessage.text = "To Implement"
        //        if cell.senderUsername.text == Auth.auth().currentUser?.email as String! {
        //            cell.avatarImageView.backgroundColor = UIColor.flatMint()
        //            cell.messageBackground.backgroundColor = UIColor.flatGray()
        //        } else {
        //
        //            cell.avatarImageView.backgroundColor = UIColor.flatRed()
        //            cell.messageBackground.backgroundColor = UIColor.flatPlum()
        //        }
        return cell
    }
    
    //TODO: Declare tableViewTapped here:
    
    func tableViewTapped(){
        print("tappepedd")
//        messageTextfield.endEditing(true)
    }
    
    //TODO: Declare configureTableView here:
    
    func configureTableView() {
//        messageTableView.rowHeight = UITableViewAutomaticDimension
//        messageTableView.estimatedRowHeight = 40
    }
    
    //Handling segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //called anytime a segue is called

        if segue.identifier == "MessageDetail"{

            print(segue.destination)
            if let dest = segue.destination as? ChatViewController,
                let index = sender as? IndexPath {

                dest.otherUser = conversationUsers[index.row] as! String
                dest.currentUser = self.currentUser

            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "MessageDetail", sender: indexPath)
        print("selected")
    }
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        performSegue(withIdentifier: "messageDetail", sender: self)
//        print("selected")
//    }
    
    ///////////////////////////////////////////
    
    
    //MARK: - Send & Recieve from Firebase

    
    
    //TODO: Create the retrieveMessages method here:
    
    func retrieveMessages() {
        
        print(currentUser)
        let messageDB = Database.database().reference().child("Messages/\(currentUser as! String)")
        
        messageDB.observe(.childAdded, with: { (snapshot) in

            let snapshotValue = snapshot.value as? [String : AnyObject] ?? [:]
            
//            for user in (snapshotValue.allKeys){
//                self.conversationUsers.append(user as! String)
//            }
            print(snapshot.ref.key)
            print(snapshotValue)
            
            self.conversationUsers.append(snapshot.ref.key)
//
//            self.conversationIds.append(snapshot.ref.key)
            print("HERE WE GO", self.conversationIds)
//            for (user, value) in snapshotValue {
//               self.conversationUsers.append(user as! String)
//            }
//
            self.configureTableView()
            self.messageTableView.reloadData()
            
        })
        
        print("yoooo", conversationUsers)
        
    }

    
    
    
}

