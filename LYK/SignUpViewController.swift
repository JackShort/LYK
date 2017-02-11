//
//  SignUpViewController.swift
//  LYK
//
//  Created by Jack Short on 1/28/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase

class SignUpViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    var ref: FIRDatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = FIRDatabase.database().reference()
    }
    
    @IBAction func signUp(_ sender: Any) {
        if !((emailLabel.text?.isEmpty)! && (usernameLabel.text?.isEmpty)! && (passwordLabel.text?.isEmpty)!) {
            let email = emailLabel.text!
            let username = usernameLabel.text!
            let password = passwordLabel.text!
            
            signUpUser(email: email, username: username, password: password)
        }
    }
    
    func signUpUser(email: String, username: String, password: String) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if (error != nil) {
                print("User was not created")
                print(error!.localizedDescription)
            } else {
                self.ref.child("users").child(user!.uid).setValue(["username": username])
                
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let containerViewController: ContainerPageViewController = sb.instantiateViewController(withIdentifier: "ContainerPageViewController") as! ContainerPageViewController
                self.present(containerViewController, animated: false, completion: nil)
            }
        })
    }
}
