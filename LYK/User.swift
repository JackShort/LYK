//
//  File.swift
//  LYK
//
//  Created by Jack Short on 2/18/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation

class User {
    var username: String
    var uid: String
    var photos: [String]
    
    init(uid: String, username: String, photos: [String]) {
        self.username = username
        self.uid = uid
        self.photos = photos
    }
}
