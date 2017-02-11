//
//  NewsFeedViewController.swift
//  LYK
//
//  Created by Jack Short on 1/16/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage

class NewsFeedViewController: UIViewController {
    @IBOutlet weak var testImageView: UIImageView!
    
    var storage: FIRStorage!
    var storageRef: FIRStorageReference!
    var currentUser: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = FIRAuth.auth()?.currentUser!
        self.storage = FIRStorage.storage()
        self.storageRef = self.storage.reference()
        
        let dataRef = self.storageRef.child(self.currentUser.uid).child("test").child("test.png")
        dataRef.downloadURL { (url, error) in
            if let error = error {
                print("there was an error downloading the url")
            } else {
                print("should have downloaded this shit")
                self.testImageView.sd_setImage(with: url)
            }
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
}
