//
//  HomeViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 3/5/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    var users = [String: String]()
    var descriptions = [String]()
    var titles = [String]()
    var prices = [Float]()
    var usernames = [String]()
    var images = [PFFile]()
    var offerBooleans = [Bool]()
    var conditions = [String]()
    var locations = [String]()
    var categories = [String]()
    
    var posts = [PFObject]()
    
    var collectionData = ["1", "2", "3", "4", "5", "6"]
    
    @IBOutlet private weak var addButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBAction func deleteSelected(_ sender: Any) {
//        if let selected = collectionView.indexPathsForSelectedItems {
//            let items = selected.map{$0.item}.sorted().reversed() //in order to safely remove from list (think about it)
//            for item in items {
//                collectionData.remove(at: item)
//            }
//            collectionView.deleteItems(at: selected)
//            navigationController?.isToolbarHidden = true
//        }
    }
    @IBAction func addItem() {

    }
    @objc func refresh() {
        addItem()
        collectionView.refreshControl?.endRefreshing()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
//        collectionView.setContentInset
        //Creates refresher for view, calls the addItem() method every time
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: UIControlEvents.valueChanged)
        
        collectionView.refreshControl = refresh
        
        let width = (collectionView.frame.size.width - 4) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
//        layout.sectionInset = UIEdgeInsets(top: -40, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: width, height: width)
        layout.minimumInteritemSpacing = 2
        layout.minimumLineSpacing = 2
        
        navigationItem.leftBarButtonItem = editButtonItem
        navigationController?.isToolbarHidden = true
        
        let query = PFUser.query()
        
        query?.findObjectsInBackground(block: { (objects, error) in
            
            if let users = objects {
                
                for object in users {
                    
                    if let user = object as? PFUser {
                        
                        self.users[user.objectId!] = user.username!
                        
                    }
                    
                }
                
            }
            
        })
        
        let postQuery = PFQuery(className: "Post")
        
        postQuery.findObjectsInBackground(block: {(objects, error) in
            
            if let posts = objects {
                
                for post in posts {
                    self.posts.append(post as! PFObject)
                    
                    self.descriptions.append(post["description"] as! String)
                    self.usernames.append(post["userid"] as! String)
                    self.titles.append(post["title"] as! String)
                    self.images.append(post["imageFile"] as! PFFile)
                    self.prices.append(Float(post["price"] as! String)!)
                    self.offerBooleans.append(post["offers"] as! Bool)
                    self.conditions.append(post["condition"] as! String)
                    self.locations.append(post["location"] as! String)
                    self.categories.append(post["category"] as! String)
                    
                    self.collectionView?.reloadData()
                    
                }
            }
        })

        // Do any additional setup after loading the view.
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //called anytime a segue is called
        if segue.identifier == "DetailSegue"{ //passing values over if the segue is the DetailSegue
            if let dest = segue.destination as? DetailsViewController,
                let index = sender as? IndexPath {
//                        dest.priceValue = prices[index.row]
                    dest.post = posts[index.row]
//                        dest.titleValue = titles[index.row]
                    dest.mainImage = images[index.row]
//                        dest.descriptionValue = descriptions[index.row]
//                        dest.priceValue = prices[index.row]
//                        dest.userId = usernames[index.row]
                
            }
        }
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        addButton.isEnabled = !editing
        deleteButton.isEnabled = editing
        
        if !editing {
            navigationController?.isToolbarHidden = true
        }
        collectionView.allowsMultipleSelection = editing
        
        let indexes = collectionView.indexPathsForVisibleItems
        for index in indexes {
            let cell = collectionView.cellForItem(at: index) as! CollectionViewCell
            cell.isEditing = editing
        }
        
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //numberOfItemsInSection (returns number of rows)
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //cellForItemAt (returns cell for index of collectionView
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        
        images[indexPath.row].getDataInBackground { (data, error) in //indexPath.row = keeps track of which index the table is populating
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData){
                    
                    cell.postImage.image = imageToDisplay
                    
                }
            }
        }

//        cell.titleLabel.text = collectionData[indexPath.row]
        cell.isEditing = isEditing
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isEditing {
            performSegue(withIdentifier: "DetailSegue", sender: indexPath)   
        } else {
            navigationController?.isToolbarHidden = false
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if isEditing {
            if let selected = collectionView.indexPathsForSelectedItems,
                selected.count == 0 {
                navigationController?.isToolbarHidden = true
            }
        }
    }
    
    
}
