//
//  NFPickerViewController.swift
//  LYK
//
//  Created by Jack Short on 2/18/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import Koloda

class NFPickerViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource{
    @IBOutlet weak var kolodaView: KolodaView!
    
    var photos: [UIImage]!
    var goodPhotos: [UIImage]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kolodaView.delegate = self
        self.kolodaView.dataSource = self
        
        //setup colors
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.photos.count
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            self.goodPhotos?.append(self.photos[index])
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = CardView.instanceFromNib() as! CardView
        cardView.imageView.image = self.photos[index]
        return cardView
    }
}
