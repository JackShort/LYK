//
//  ViewController.swift
//  LYK
//
//  Created by Jack Short on 1/16/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var appName = "LYK"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //uinavigation controller shit
        self.navigationController?.navigationBar.topItem?.title = appName
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64.0)
        
        //register clases for uitableview
        self.tableView.register(FeedTableViewCell.classForCoder(), forCellReuseIdentifier: "feedCell")
        self.tableView.register(UINib(nibName: "FeedTableViewCell", bundle: nil), forCellReuseIdentifier: "feedCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64.0)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 64.0)
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }

    //UITableViewFunctions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "feedCell")! as! FeedTableViewCell
        
        cell.groupNameLabel.text = "Jack"
        cell.contextLabel.text = "Jackson: I hate jack"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = self.tableView.cellForRow(at: indexPath) as! FeedTableViewCell
        self.performSegue(withIdentifier: "openConversationSegue", sender: cell)
    }
    
    //segue shit
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "openConversationSegue" {
            let vc = segue.destination as! ConversationViewController
            let cell = sender as! FeedTableViewCell
            vc.groupName = cell.groupNameLabel.text!
        }
    }
}

