//
//  ConversationViewController.swift
//  LYK
//
//  Created by Jack Short on 1/16/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var groupName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigation bar shit
        self.title = groupName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = true
    }
    
    //tableview shit
    
    //sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    //rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
   
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    //cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
