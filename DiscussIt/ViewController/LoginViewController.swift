//
//  LoginViewController.swift
//  DiscussIt
//
//  Created by ehsan sat on 3/15/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var userName: UISearchBar!
    
    @IBOutlet weak var password: UISearchBar!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBOutlet weak var loginGuestButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
 
        
        userName.delegate = self
        password.delegate = self
        
        loginButton.layer.cornerRadius = 15
        loginGuestButton.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
//        Auth.auth().addStateDidChangeListener { (auth, user) in
//            if user != nil {
//                // user is signed in go to tab bar controller
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController")
//                self.present(vc!, animated: true, completion: nil)
//            }
//        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        
        if let email = userName.text, let password = password.text {
            Auth.auth().signIn(withEmail: email, password: password) { (authDataResult, err) in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                let authUser = Auth.auth().currentUser
                if authUser != nil && !authUser!.isEmailVerified {
                    // user is available but their email is not verified
                    // alert with an option to resent email verification
                    let alert = UIAlertController(title: "Email Is Not Verified", message: "Your Email Is Not Verified", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Resend", style: .default, handler: { (action) in
                        let authUser = Auth.auth().currentUser
                        authUser?.sendEmailVerification(completion: { (err) in
                            if err != nil {
                                print(err!)
                            }
                        })
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
//               self.present(self.tabBarController!, animated: true, completion: nil)
                self.performSegue(withIdentifier: "goToTabBar", sender: self)
            }
        }
    }
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToReset", sender: self)
    }
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToSignUp", sender: self)
    }
    
    @IBAction func loginGuestPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToTabBar", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReset" {
            let vc = segue.destination as! ResetViewController
        } else if segue.identifier == "goToSignUp" {
            let vc = segue.destination as! SignUpViewController
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
