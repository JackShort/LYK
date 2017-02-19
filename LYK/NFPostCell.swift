//
//  NFTableViewCell.swift
//  LYK
//
//  Created by Jack Short on 2/11/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit

class NFPostCell: UITableViewCell {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    
    var photos: [UIImage]!
    var color: UIColor!
    var photoHasBeenSet: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.color = UIColor.randomFlat()
        
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.flatGray().cgColor
        
        if !photoHasBeenSet {
            self.previewImageView.image = UIImage(named: "placeholder_image")
        }
        
//        self.contentView.layer.cornerRadius = self.contentView.frame.size.height / 8
//        self.contentView.layer.masksToBounds = true
//        self.contentView.layer.frame = CGRect(x: (self.frame.size.width - 360) / 2, y: 0, width: 360, height: self.contentView.layer.frame.height)
    }
    
    func setUsernameLabel(name: String) {
        self.usernameLabel.text = name
    }
    
    func setPhotos(photos: [UIImage]) {
        let photo = photos.last
        photoHasBeenSet = true
        self.previewImageView.image = photo
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.previewImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.previewImageView.addSubview(blurEffectView)
        
        self.photos = photos
    }
}
