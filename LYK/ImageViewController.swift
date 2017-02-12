//
//  ImageViewController.swift
//  LYK
//
//  Created by Jack Short on 1/17/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var storageRef: FIRStorageReference!
    var ref: FIRDatabaseReference!
    var photo: UIImage!
    var currentUser: FIRUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = FIRAuth.auth()?.currentUser!
        self.storageRef = FIRStorage.storage().reference()
        self.ref = FIRDatabase.database().reference()
        
        imageView.image = photo
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func post(_ sender: Any) {
        let photoRef: FIRDatabaseReference = self.ref.child("photos").childByAutoId()
        photoRef.setValue(["user": self.currentUser.uid, "title": "test"])
        let photoId: String = photoRef.key
        
        let userPhotoRef: FIRDatabaseReference = self.ref.child("users").child(self.currentUser.uid).child("photos").child(photoId)
        userPhotoRef.setValue(true)
        
        let data: Data = UIImagePNGRepresentation(self.photo)!
        let dataRef = self.storageRef.child(self.currentUser.uid).child("\(photoId).png")
        let uploadTask = dataRef.put(data)
        
        uploadTask.observe(.resume) { (snapshot) in
            print("the picture is being uploaded")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("the file has been uploaded")
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            print("something went wrong in the upload")
            photoRef.removeValue()
            userPhotoRef.removeValue()
        }
        
        self.dismiss(animated: false, completion: nil)
    }
}
