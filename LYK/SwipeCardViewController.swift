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
    }
    
    // koloda functions 
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return 1
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView()
    }
}
