//
//  File.swift
//  LYK
//
//  Created by Jack Short on 2/18/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import Koloda

class SwipeCardViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource {
    @IBOutlet weak var kolodaView: KolodaView!
    
    var image: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        print(self.image)
        
        self.navigationController?.navigationBar.barTintColor = UIColor.flatBlack()
        self.navigationController?.navigationBar.tintColor = UIColor.flatWhite()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.flatWhite()]
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    // koloda functions 
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 1
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = CardView.instanceFromNib() as! CardView
        cardView.imageView.image = self.image
        
        return cardView
    }
}
