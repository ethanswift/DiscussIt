//
//  BoardTableViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 3/2/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseFirestore

class BoardTableViewController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var searchBar: UITableView!
    
    var db: Firestore!
    
    var workArray: [Work] = []
    
    var filteredData: [Work]!
    
    var filteredTitle: [String]!
    var filteredDescription: [String]!
    var filteredAuthor: [String]!
    var filteredURL: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        searchBar.delegate = self
        filteredData = workArray
        retrieveData()
        tableView.backgroundColor = #colorLiteral(red: 0.2265214622, green: 0.2928299606, blue: 0.5221264958, alpha: 1)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return workArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bCell", for: indexPath)
        if indexPath.row == 0 {
            // title
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.text = workArray[indexPath.section].title
            cell.textLabel?.textAlignment = .center
        } else if indexPath.row == 1 {
            // info
            cell.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell.textLabel?.textColor = #colorLiteral(red: 0.4352941176, green: 0.4431372549, blue: 0.4745098039, alpha: 1)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.text = workArray[indexPath.section].type + " in " + workArray[indexPath.section].containerTitle
            cell.textLabel?.textAlignment = .center
        } else if indexPath.row == 2 {
            // authors
            cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.text = workArray[indexPath.section].author
            cell.textLabel?.textAlignment = .center
        } else {
            // url
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 20
            cell.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cell.textLabel?.textColor = #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
            cell.textLabel?.text = workArray[indexPath.section].url
            cell.textLabel?.textAlignment = .center
        }
        // Configure the cell...
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            performSegue(withIdentifier: "goToWorkFromBoard", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        (view as! UITableViewHeaderFooterView).contentView.backgroundColor = #colorLiteral(red: 0.2265214622, green: 0.2928299606, blue: 0.5221264958, alpha: 1)
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? workArray : workArray.filter{$0.title.contains(searchText) || $0.containerTitle.contains(searchText) || $0.author.contains(searchText) || $0.doi.contains(searchText)}
        tableView.reloadData()
    }
    
    // MARK: - Data
    
    func retrieveData() {
        let newDB = db.collection("works")
        newDB.getDocuments { (querySnapshot, error) in
            if let err = error {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    let dataValue = document.data()
//                    let documentId = dataValue["documentId"] as! String
                    let doi = dataValue["doi"] as! String
                    let title = dataValue["title"] as! String
                    let containerTitle = dataValue["containerTitle"] as! String
                    let author = dataValue["author"] as! String
                    let publisher = dataValue["publisher"] as! String
                    let type = dataValue["type"] as! String
                    let page = dataValue["page"] as! String
                    let url = dataValue["url"] as! String
                    let issued = dataValue["issued"] as! String
                    let newBoardWork = Work(title: title, type: type, issued: issued, containerTitle: containerTitle, page: page, publisher: publisher, author: author, doi: doi, url: url)
                    self.workArray.append(newBoardWork)
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToWorkFromBoard" {
            let indexPath = tableView.indexPathForSelectedRow
            let selectedSection = indexPath?.section
            let vc = segue.destination as! WorkViewController
            vc.newWork = workArray[selectedSection!]   
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}
