//
//  CardView.swift
//  LYK
//
//  Created by Jack Short on 2/18/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    @IBOutlet weak var imageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.masksToBounds = true
        self.layer.cornerRadius = self.frame.size.height / 32
    }
    
    func setImage(image: UIImage) {
        imageView.image = image
    }
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
}
