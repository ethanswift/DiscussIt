//
//  SignUpViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 3/15/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController, UISearchBarDelegate {
    
    var authUser = Auth.auth().currentUser
    
    @IBOutlet weak var displayName: UISearchBar!

    @IBOutlet weak var userName: UISearchBar!
    
    @IBOutlet weak var password: UISearchBar!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var backToLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        signUpButton.layer.cornerRadius = 15
        backToLoginButton.layer.cornerRadius = 15

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        if displayName.text == "" || userName.text == "" || password.text == "" {
            signUpButton.isEnabled = false
            signUpButton.titleLabel?.text = "Ooops! A Field Is Empty!!"
        } else if (password.text?.count)! < 6 {
            signUpButton.isEnabled = false
            signUpButton.titleLabel?.text = "Ooops!"
            password.backgroundColor = #colorLiteral(red: 0.8881979585, green: 0.3072378635, blue: 0.2069461644, alpha: 0.7102953767)
            password.placeholder = "You Should Enter 6 Charachter Or More"
        } else {
        if let email = userName.text, let password = password.text {
            Auth.auth().createUser(withEmail: email, password: password) { (resultUser, err) in
                if err != nil {
                    print(err!.localizedDescription)
                }
                guard err != nil else {return}
                guard resultUser != nil else {return}
                if let authUser = Auth.auth().currentUser {
                    let changeRequest = authUser.createProfileChangeRequest()
                    changeRequest.displayName = self.displayName.text
                    changeRequest.commitChanges(completion: { (error) in
                        if error != nil {
                            print(error!.localizedDescription)
                        }
                    })
                }
                let authUser = Auth.auth().currentUser
                if authUser != nil && !authUser!.isEmailVerified {
                    authUser?.sendEmailVerification(completion: { (err) in
                        if err != nil {
                            print(err!)
                        }
                        // notify the user that email has been sent
                        let alert = UIAlertController(title: "Account Created", message: "An Email Has Been Sent, Please Check Your Email And Verify Your Account", preferredStyle: .alert)
                        self.present(alert, animated: true, completion: nil)
                    })
                } else {
                    self.performSegue(withIdentifier: "goToTabBarFromSignUp", sender: self)
                }
            }
        }
     }
    }
    
    @IBAction func backToLoginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goBackToLoginFromSignUp", sender: self)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        signUpButton.isEnabled = true
        signUpButton.titleLabel?.text = "Sign Up"
        password.backgroundColor = UIColor.clear
        password.placeholder = "Password"
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
