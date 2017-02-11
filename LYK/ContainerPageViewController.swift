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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        createViewControllers()
        setupViewControllers()
    }
    
    //status bar shit
    override var prefersStatusBarHidden: Bool {
        return isHidden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    //custom methods
    func createViewControllers() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let feedTabBarController: UITabBarController = sb.instantiateViewController(withIdentifier: "FeedTabBarController") as! UITabBarController
        let cameraViewController: CameraViewController = sb.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
        let newsFeedViewController: NewsFeedViewController = sb.instantiateViewController(withIdentifier: "NewsFeedViewController") as! NewsFeedViewController
        
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
