//
//  SignUpViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 3/15/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
//    var authUser = Auth.auth().currentUser
    
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
        if let email = userName.text, let password = password.text {
            Auth.auth().createUser(withEmail: email, password: password) { (authDataResutl, err) in
                if err != nil {
                    print(err!.localizedDescription)
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
    
    @IBAction func backToLoginPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goBackToLoginFromSignUp", sender: self)
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
