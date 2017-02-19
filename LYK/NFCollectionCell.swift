//
//  NFCollectionCell.swift
//  LYK
//
//  Created by Jack Short on 2/19/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit

class NFCollectionCell: UICollectionViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likePhotoButton: UIButton!
    
    var color: UIColor!
    var photos: [UIImage]!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.imageView.layer.borderWidth = 2
        self.imageView.layer.borderColor = UIColor.flatWhite().cgColor
        self.imageView.layer.masksToBounds = true
        self.imageView.layer.cornerRadius = self.imageView.frame.size.height / 2
    }
    
    func setColor(color: UIColor) {
        self.backgroundColor = color
        self.color = color
    }
    
    func setPhotos(photos: [UIImage]) {
        self.photos = photos
        self.imageView.image = self.photos.last
    }
    
    @IBAction func liked(_ sender: Any) {
        self.likePhotoButton.setImage(UIImage(named: "liked"), for: .normal)
    }
}
