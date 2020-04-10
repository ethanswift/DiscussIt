//
//  ResetViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 3/15/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseAuth

class ResetViewController: UIViewController {
    
    @IBOutlet weak var emailBar: UISearchBar!
    
    @IBOutlet weak var resetButton: UIButton!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        resetButton.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: emailBar.text!) { (error) in
            if error != nil {
                print(error?.localizedDescription)
            }
            let alert = UIAlertController(title: "Email Sent", message: "An Email Has Been Sent, Please Check Your Email And Reset Your Password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
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
