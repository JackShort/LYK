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

class CameraPickerViewController: UIViewController, KolodaViewDelegate, KolodaViewDataSource{
    @IBOutlet weak var kolodaView: KolodaView!
    
    var photos: [UIImage]!
    var goodPhotos: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.kolodaView.delegate = self
        self.kolodaView.dataSource = self
        
        self.goodPhotos = [UIImage]()
        
        //setup colors
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.photos.count
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        self.performSegue(withIdentifier: "unwindFromPicker", sender: self)
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        if direction == .right {
            self.goodPhotos?.append(self.photos[index])
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindFromPicker" {
            let vc = segue.destination as! CameraViewController
            vc.setPhotosTaken(photos: self.goodPhotos)
        }
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        let cardView = CardView.instanceFromNib() as! CardView
        cardView.imageView.image = self.photos[index]
        return cardView
    }
}
