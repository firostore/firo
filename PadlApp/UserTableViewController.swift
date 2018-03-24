//
//  UserTableViewController.swift
//  
//
//  Created by Jason Tang on 2/20/18.
//
//

import UIKit
import Parse

class UserTableViewController: UITableViewController, UISearchResultsUpdating {
    
    var titles = [""]
    var objectIds = [""]
    var isFollowing = ["" : true]
    
    var refresher: UIRefreshControl = UIRefreshControl()
    var searchController = UISearchController(searchResultsController: nil)
    
    @objc func updateTable(searchInput: String) {
        let query = PFQuery(className: "Post")
        
        query.findObjectsInBackground(block: { (objects, error) in
            
            if error != nil {
                
                print(error)
                
            } else {
                if let posts = objects {
                    for post in posts {
                        var cellText = post["title"] as! String?
                        print("retrieved some posts!!")
                        if (self.title?.lowercased().contains(searchInput.lowercased()))!{
                            print("found one!!")
                            self.titles.append(cellText!)
                            self.objectIds.append(post.objectId!)
                        } else if searchInput == "" {
//                            self.titles.append(self.title!)
//                            self.objectIds.append(post.objectId!)
                        }

                        
                    }
                    
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
                
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateTable(searchInput: "")
        
        refresher.attributedTitle = NSAttributedString(string: "Pull to refresh")
        
        refresher.addTarget(self, action: #selector(UserTableViewController.updateTable), for: UIControlEvents.valueChanged)
        
        tableView.addSubview(refresher)
        
        definesPresentationContext = true

//        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
//        searchController.searchBar.delegate = self
//        searchController.searchBar.sizeToFit()
//        searchController.searchBar.searchBarStyle = UISearchBarStyle.minimal
        tableView.tableHeaderView = searchController.searchBar
    
        searchController.searchResultsUpdater = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //resets tableview when view is refreshed
        searchController.searchBar.text = nil
        titles = []
        objectIds = []
        
        self.tableView.reloadData()
    }
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        searchController.isActive = false
//        searchController.searchBar.removeFromSuperview()
//        definesPresentationContext = false
//    }
//    
    func updateSearchResults(for searchController: UISearchController) {
        print("called update search")
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
//            filteredNFLTeams = unfilteredNFLTeams.filter { team in
//                return team.lowercased().contains(searchText.lowercased())
//            }
            titles = []
            objectIds = []
            updateTable(searchInput: searchText)
            print("searching for ", searchText)
            
        } else {
//            updateTable(searchInput: "")
        }
//        tableView.reloadData()
    }
    
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        print("called update search")
//        
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = titles[indexPath.row]
        
//        if let followsBoolean = isFollowing[objectIds[indexPath.row]] {
//            
//            if followsBoolean {
//                
//                cell.accessoryType = UITableViewCellAccessoryType.checkmark
//                
//            }
//        }
//    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { //method called upon clicking within a cell
        
        let cell = tableView.cellForRow(at: indexPath)
        
//        print("clcikeddied")
//        
//        if let followsBoolean = isFollowing[objectIds[indexPath.row]] {
//            
//            if followsBoolean {
//                
//                isFollowing[objectIds[indexPath.row]] = false
//                
//                cell?.accessoryType = UITableViewCellAccessoryType.none
//                
//                let query = PFQuery(className: "Following")
//                
//                query.whereKey("follower", equalTo: PFUser.current()?.objectId)
//                query.whereKey("following", equalTo: objectIds[indexPath.row])
//                
//                query.findObjectsInBackground(block: { (objects, error) in
//                    
//                    if let objects = objects {
//                        
//                        for object in objects {
//                            
//                            object.deleteInBackground()
//                            
//                        }
//                        
//                    }
//                    
//                })
//                
//            } else {
//                
//                isFollowing[objectIds[indexPath.row]] = true
//                
//                cell?.accessoryType = UITableViewCellAccessoryType.checkmark
//                
//                let following = PFObject(className: "Following")
//                
//                following["follower"] = PFUser.current()?.objectId
//                
//                following["following"] = objectIds[indexPath.row]
//                
//                following.saveInBackground()
//                
//                
//            }
//            
//        }
    }

//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
