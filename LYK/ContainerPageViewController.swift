//
//  ContainerViewController.swift
//  LYK
//
//  Created by Jack Short on 1/16/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class ContainerPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var orderedViewControllers: [UIViewController] = []
    var isHidden = true
    
    var user: User!
    var currentUser: FIRUser!
    var ref: FIRDatabaseReference!
    
//    var nfView: NewsFeedViewController!
    var nfView: NFViewController!
    var fView: FeedViewController!
    var cameraView: CameraViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        self.ref = FIRDatabase.database().reference()
        self.currentUser = FIRAuth.auth()?.currentUser
        
        createViewControllers()
        setupViewControllers()
    }
    
    //status bar shit
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    //user methods
    func getUser() {
        self.ref.child("users").child(self.currentUser.uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let username = value["username"] as! String
            let friendsDict = value["friends"] as? NSDictionary
            let uid = self.currentUser.uid
            
            if friendsDict == nil {
                self.user = User(uid: uid, username: username)
            } else {
                let friends = friendsDict?.allKeys as! [String]
                self.user = User(uid: uid, username: username, friends: friends)
            }
            
            self.cameraView.user = self.user
            self.nfView.user = self.user
            if self.nfView.isViewLoaded {
                self.nfView.setUserLoaded(b: true)
            } else {
                self.nfView.userLoaded = true
            }
            self.fView.user = self.user
        })
    }
    
    //custom methods
    func createViewControllers() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let feedTabBarController: UITabBarController = sb.instantiateViewController(withIdentifier: "FeedTabBarController") as! UITabBarController
        let cameraViewController: CameraViewController = sb.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
//        let newsFeedViewController: UINavigationController = sb.instantiateViewController(withIdentifier: "NFNavigationController") as! UINavigationController
        let newsFeedViewController: NFViewController = sb.instantiateViewController(withIdentifier: "NFViewController") as! NFViewController
        
//        self.nfView = newsFeedViewController.viewControllers[0] as! NewsFeedViewController
        self.nfView = newsFeedViewController
        let fnav = feedTabBarController.viewControllers?[0] as! UINavigationController
        self.fView = fnav.viewControllers[0] as! FeedViewController
        self.cameraView = cameraViewController
        
        getUser()
        
        self.orderedViewControllers.append(feedTabBarController)
        self.orderedViewControllers.append(cameraViewController)
        self.orderedViewControllers.append(newsFeedViewController)
    }
    
    func setupViewControllers() {
        setViewControllers([self.orderedViewControllers[1]], direction: .forward, animated: true, completion: nil)
    }
    
    //pageviewcontroller methods
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard self.orderedViewControllers.count > previousIndex else {
            return nil
        }
        
        return self.orderedViewControllers [previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let index = self.orderedViewControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = index + 1
        
        guard nextIndex < self.orderedViewControllers.count else {
            return nil
        }
        
        guard nextIndex != self.orderedViewControllers.count else {
            return nil
        }
        
        return self.orderedViewControllers[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        let viewController = pendingViewControllers[0]
        let index = self.orderedViewControllers.index(of: viewController)
        
        if index == 1 {
            isHidden = true
        } else {
        }
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let viewController = previousViewControllers[0]
        let currentViewController = pageViewController.viewControllers![0]
        let previousIndex = self.orderedViewControllers.index(of: viewController)
        let index = self.orderedViewControllers.index(of: currentViewController)
        
        if previousIndex != index {
            if previousIndex != 1 {
                isHidden = true
            } else {
                isHidden = false
            }
            setNeedsStatusBarAppearanceUpdate()
        }
    }
}
