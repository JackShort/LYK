//
//  ProfileViewController.swift
//  LYK
//
//  Created by Jack Short on 1/16/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    var username: String! = "Jack Short"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationbar shit
        self.navigationController?.navigationBar.topItem?.title = username
    }
}
