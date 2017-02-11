//
//  LogInViewController.swift
//  LYK
//
//  Created by Jack Short on 1/28/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Firebase

class LogInViewController: UIViewController {
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // login button action
    @IBAction func logIn(_ sender: Any) {
        if !((emailLabel.text?.isEmpty)! && (passwordLabel.text?.isEmpty)!) {
            let email = emailLabel.text!
            let password = passwordLabel.text!
            
            self.logInUser(email: email, password: password)
        }
    }
    
    // log in user
    func logInUser(email: String, password: String) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print("could not log in")
                print(error!.localizedDescription)
            } else {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let containerViewController: ContainerPageViewController = sb.instantiateViewController(withIdentifier: "ContainerPageViewController") as! ContainerPageViewController
                self.present(containerViewController, animated: false, completion: nil)
            }
        })
    }
    
//    func logInUser(username: String, password: String) {
//            // send post request with login info
//            var request = URLRequest(url: URL(string: apiUrl)!)
//            
//            request.httpMethod = "POST"
//            let postString = "username=\(username)&password=\(password)"
//            request.httpBody = postString.data(using: .utf8)
//            
//            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
//                // if there is an error
//                guard let data = data, error == nil else {
//                    print("error=\(error)")
//                    return
//                }
//                
//                // if a status code thats not 200 is passed
//                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
//                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
//                    print("response = \(httpStatus)")
//                }
//                
//                print(String(data: data, encoding: String.Encoding.utf8)!)
//
//                // handle json
////                do {
////                    let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: String]
////                    print(json!)
////                }
//            })
//            
//            task.resume()
//    }
}
