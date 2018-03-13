//
//  ConditionTableViewController.swift
//  PadlApp
//
//  Created by Jason Tang on 3/13/18.
//  Copyright © 2018 Padl. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    var typeId: Int! //identifies which table user wants: 1-condition, 2-category, 3-location
    var data = [String]()
    var selected: String?
    
    var conditions = ["New", "Like New", "Good", "Acceptable"]
    var categories = ["Men's Clothing, Shoes & Accessories", "Women's Clothing, Shoes & Accessories", "Electronics", "Books & Academic Materials", "Musical Instruments & Accessories", "Home, Dorm & Garden", "Sporting Goods", "Health & Beauty", "Art & Collectibles", "Entertainment", "Speciality Services", "Food & Beverages"]
    var locations = ["Baker", "Burton-Conner", "East Campus", "Greek Housing - Cambridge", "Greek Housing - Boston", "MacGregor", "Maseeh", "McCormick", "New", "Next", "Random", "Simmons", "Other"]
    //locations will change by school and campus
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        
        if typeId == 1 {
            data = conditions
        } else if typeId == 2 {
            data = categories
        } else {
            data = locations
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) { //called anytime a segue is called
        if segue.identifier == "unwindToPost"{ //passing values over if the segue is the DetailSegue
            if let dest = segue.destination as? PostViewController,
                let index = sender as? IndexPath {
                //                        dest.priceValue = prices[index.row]
                if typeId == 1 {
                    dest.condition = data[index.row]
//                    print(dest.conditionLabel.text)
//                    print(data[index.row])
//                    dest.conditionLabel.text = data[index.row]
                } else if typeId == 2 {
                    dest.category = data[index.row]
                } else {
                    dest.location = data[index.row]
                }
                
            }
        }
    }

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
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optioncell", for: indexPath) as! CategoryTableViewCell

        cell.optionTextLabel.text = data[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selected = data[indexPath.row]
        
        performSegue(withIdentifier: "unwindToPost", sender: indexPath)

    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
