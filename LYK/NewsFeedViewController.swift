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

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var storage: FIRStorage!
    var storageRef: FIRStorageReference!
    var currentUser: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = FIRAuth.auth()?.currentUser!
        self.storage = FIRStorage.storage()
        self.storageRef = self.storage.reference()
        
//        let dataRef = self.storageRef.child(self.currentUser.uid).child("test").child("test.png")
//        dataRef.downloadURL { (url, error) in
//            if let error = error {
//                print("there was an error downloading the url")
//            } else {
//                print("should have downloaded this shit")
//                self.testImageView.sd_setImage(with: url)
//            }
//        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: 21))
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
