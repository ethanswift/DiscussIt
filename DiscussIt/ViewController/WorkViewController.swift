//
//  WorkViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 2/28/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseFirestore

class WorkViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var authorsLabel: UILabel!
    
    @IBOutlet weak var doiLabel: UILabel!
    
    @IBOutlet weak var createButton: UIButton!
    
    @IBOutlet weak var webButton: UIButton!
    
    @IBOutlet weak var boardsTables: UITableView!
    
    var boardName : String = ""
    
    var newWork: Work = Work()
    
    var boardNames: [String] = []
    
    var db: Firestore!
    
    var refrenceNumber: String = ""
    
    var refNumTable: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        boardsTables.delegate = self
        boardsTables.dataSource = self
        titleLabel.text = newWork.title
        titleLabel.clipsToBounds = true
        titleLabel.layer.cornerRadius = 20
        titleLabel.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        descriptionLabel.text = newWork.type + (newWork.issued == "" ? "" : " published \(newWork.issued)") + (newWork.containerTitle == "----------" ? "" : " in \(newWork.containerTitle)") + (newWork.page == "----------" ? "" : " on pages \(newWork.page)") + (newWork.publisher == "----------" ? "" : " by \(newWork.publisher)")
        authorsLabel.text = newWork.author
        doiLabel.text = newWork.url
        doiLabel.clipsToBounds = true
        doiLabel.layer.cornerRadius = 20
        doiLabel.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        createButton.layer.cornerRadius = 20
        webButton.layer.cornerRadius = 20
        checkWorkDocs()
        boardsTables.reloadData()
   
    }

    @IBAction func createButtonPressed(_ sender: UIButton) {

        let alert = UIAlertController(title: "Create A Discussion Room", message: "Choose A Name", preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.delegate = self
            textField.placeholder = "Add A Name"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (alertAction) in
            let textField = alert.textFields?[0] as! UITextField
            let alertText = textField.text
            print(alertText!)
            self.boardName = alertText!
            self.addWorkData(text: alertText!)
            self.performSegue(withIdentifier: "goToChat", sender: self)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func webButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToWeb", sender: self)
    }
    
    func addWorkData (text: String) {
        let ref = db.collection("works").document().documentID
        self.refrenceNumber = ref
        let newDB = db.collection("works").document(ref)
//        let ref = newDB.documentID
        newDB.setData(["documentId": ref,
                       "doi": newWork.doi,
                       "title": newWork.title,
                       "containerTitle": newWork.containerTitle,
                       "author": newWork.author,
                       "publisher": newWork.publisher,
                       "type": newWork.type,
                       "page": newWork.page,
                       "url": newWork.url,
                       "issued": newWork.issued,
                       "boardName": text])
        newDB.collection(text)
    }
    
    // MARK: - TableView Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.boardNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "boardsCell", for: indexPath)
        cell.textLabel?.text = self.boardNames[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        cell.backgroundColor = #colorLiteral(red: 0.2265214622, green: 0.2928299606, blue: 0.5221264958, alpha: 1)
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "secondGoToChat", sender: self)
    }
    
    // MARK: - Works Docs

    func checkWorkDocs () {
        let existingDocs = db.collection("works")
        existingDocs.whereField("doi", isEqualTo: newWork.doi).getDocuments { (querySnapshot, err) in
            if err != nil {
                print(err!)
            } else {
                for document in querySnapshot!.documents {
                    if document.exists {
                        print(document.data())
                    let dataValue = document.data()
                        if let boardNameValue = dataValue["boardName"] as? String, let refValue = dataValue["documentId"] as? String {
                            self.boardNames.append(boardNameValue)
                            self.refNumTable.append(refValue)
//                            self.refrenceNumber = refValue
                            print(self.boardNames)
                            print(self.refrenceNumber)
                            self.boardsTables.reloadData()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToChat" {
            let vc = segue.destination as! ChatViewController
            vc.boardName = boardName
            vc.ref = refrenceNumber
        } else if segue.identifier == "goToWeb" {
           let vc = segue.destination as! WebViewController
            vc.url = newWork.url
        } else if segue.identifier == "secondGoToChat" {
            let vc = segue.destination as! ChatViewController
            let selected = boardsTables.indexPathForSelectedRow
            let selectedRow = selected?.row
            print(selectedRow!)
            print("ref and baordName: ", refrenceNumber, boardNames[selectedRow!])
            vc.boardName = boardNames[selectedRow!]
            vc.ref = refNumTable[selectedRow!]
//            vc.ref = refrenceNumber
        }
    }
}
