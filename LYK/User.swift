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
    var friends: [String]
    
    init(uid: String, username: String) {
        self.username = username
        self.uid = uid
        self.friends = [String]()
    }
    
    init(uid: String, username: String, friends: [String]) {
        self.username = username
        self.uid = uid
        self.friends = friends
    }
    
    var description : String {
        return "Username: \(self.username)"
    }
}
