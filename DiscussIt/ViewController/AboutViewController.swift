//
//  AboutViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 4/10/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseAuth

class AboutViewController: UIViewController {
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var logOutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        logOutButton.layer.cornerRadius = 15
        descriptionLabel.layer.cornerRadius = 15
        
        descriptionLabel.text = "This is an app to enhance your ability to search for academic content and specifically investigating scholarly articles. You're going to get connected to CrossRef search engine and look into ?? articles which are available. If interested, you can open one and start a discussion forum with your colleagues or classmates and talk about it in detail."

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logOutPressed(_ sender: Any) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
            } catch {
                print(error)
            }
            // perform segue to login page
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
