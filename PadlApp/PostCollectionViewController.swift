//
//  PostCollectionViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 3/3/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse


class PostCollectionViewController: UICollectionViewController {
    
    private let reuseIdentifier = "PostCell"
    fileprivate let itemsPerRow: CGFloat = 3
    fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    
    var users = [String: String]()
    var comments = [String]()
    var usernames = [String]()
    var images = [PFFile]()
    
//    var largePhotoIndexPath: IndexPath? { //Holds index path fo the tapped photo if it exists
//        didSet {
//            //Did sets manages the update of the collection view if updated
//            var indexPaths = [IndexPath]()
//            if let largePhotoIndexPath = largePhotoIndexPath {
//                indexPaths.append(largePhotoIndexPath)
//            }
//            if let oldValue = oldValue {
//                indexPaths.append(oldValue)
//            }
//            //3
//            collectionView?.performBatchUpdates({
//                self.collectionView?.reloadItems(at: indexPaths)
//            }) { completed in
//                //shows enlarged cell
//                if let largePhotoIndexPath = self.largePhotoIndexPath {
//                    self.collectionView?.scrollToItem(
//                        at: largePhotoIndexPath,
//                        at: .centeredVertically,
//                        animated: true)
//                }
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let width = (collectionView?.frame.size.width)! / 3
//        let layout
        
        let query = PFUser.query()
        
        query?.whereKey("username", notEqualTo: PFUser.current()?.username)
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                    
                }
                
            }
            
        })
        
        let getFollowedUsersQuery = PFQuery(className: "Following")
        
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.current()?.objectId)
        
        getFollowedUsersQuery.findObjectsInBackground(block: {(objects, error) in
            
            if let followers = objects {
                
                for follower in followers {
                    
                    if let followedUser = follower["following"]{
                        
                        let query = PFQuery(className: "Post")
                        
                        query.whereKey("userid", equalTo: followedUser)
                        
                        query.findObjectsInBackground(block: {(objects, error) in
                            
                            if let posts = objects {
                                
                                for post in posts {
                                    
                                    self.comments.append(post["message"] as! String)
                                    self.usernames.append(post["userid"] as! String)
                                    self.images.append(post["imageFile"] as! PFFile)
                                    
                                    self.collectionView?.reloadData()
                                    
                                }
                            }
                        })
                    }
                }
            }
        })

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return comments.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCollectionViewCell
    
        // Configure the cell
        
        images[indexPath.row].getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData){
                    
                    cell.image.image = imageToDisplay
                    
                }
            }
        }
        
//        cell.commentLabel.text = comments[indexPath.row]
//        
//        cell.userLabel.text = usernames[indexPath.row]
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "PostHeaderView",
                                                                             for: indexPath) as! PostCollectionReusableView
            //CHANGE headerView.label.text = searches[(indexPath as NSIndexPath).section].searchTerm
            headerView.label.text = "Yooo" //to implement: custom headers
            return headerView
        default:
            //4
//            return self
//            print("yo")
            assert(false, "Unexpected element kind")
        }
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    

}

//var largePhotoIndexPath: NSIndexPath? {
//didSet {
//    //2
//    var indexPaths = [IndexPath]()
//    if let largePhotoIndexPath = largePhotoIndexPath {
//        indexPaths.append(largePhotoIndexPath as IndexPath)
//    }
//    if let oldValue = oldValue {
//        indexPaths.append(oldValue as IndexPath)
//    }
//    //3
//    collectionView?.performBatchUpdates({
//        self.collectionView?.reloadItems(at: indexPaths)
//    }) { completed in
//        //4
//        if let largePhotoIndexPath = self.largePhotoIndexPath {
//            self.collectionView?.scrollToItem(
//                at: largePhotoIndexPath as IndexPath,
//                at: .centeredVertically,
//                animated: true)
//        }
//    }
//}
//}


extension PostCollectionViewController : UICollectionViewDelegateFlowLayout {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        
//        if indexPath == largePhotoIndexPath { //Calculate size of enlarged cell to fill as much of the collection view as possible whilst maintaining an aspect ratio
//            let postPhoto = photoForIndexPath(indexPath)
//            var size = collectionView.bounds.size
//            size.height -= topLayoutGuide.length
//            size.height -= (sectionInsets.top + sectionInsets.right)
//            size.width -= (sectionInsets.left + sectionInsets.right)
//            return postPhoto.sizeToFillWidthOfSize(size)
//        }
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

//extension PostCollectionViewController {
//    
//    override func collectionView(_ collectionView: UICollectionView,
//                                 shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        
//        if largePhotoIndexPath == indexPath{ //If the clicked image is already enlarged, ignore
//            largePhotoIndexPath = nil
//        } else { //Else set path to the clicked image.
//            largePhotoIndexPath = indexPath
//        }
//
//        return false
//    }
//}

//// MARK: - UICollectionViewDelegate
//extension PostCollectionViewController {
//    
//    override func collectionView(_ collectionView: UICollectionView,
//                                 shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        
//        largePhotoIndexPath = largePhotoIndexPath == indexPath ? nil : indexPath
//        return false
//    }
//}

