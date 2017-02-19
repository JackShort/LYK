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

class PostImageViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    
    var storageRef: FIRStorageReference!
    var ref: FIRDatabaseReference!
    var photos: [UIImage]!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.storageRef = FIRStorage.storage().reference()
        self.ref = FIRDatabase.database().reference()
        print(self.photos)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @IBAction func postToCollection(_ sender: Any) {
        for photo in self.photos {
            self.post(photo: photo, collection: "personal")
        }
    }
    
    @IBAction func postToFriends(_ sender: Any) {
        var collectionRefs = [String]()
        
        for photo in self.photos {
            let collectionRef: FIRDatabaseReference = self.ref.child("collections").child("posts").childByAutoId()
            collectionRef.setValue(["uid": self.user.uid, "username": self.user.username])
            let collectionId: String = collectionRef.key
            collectionRefs.append(collectionId)
            
            storePhotoPost(photo: photo, collectionId: collectionId)
        }
        
        let title = self.titleTextField.text!
        let postRef = self.ref.child("posts").childByAutoId()
        let postId = postRef.key
        //FIX this part if the photos fail
        let json = [
            "photos": collectionRefs,
            "username": self.user.username,
            "uid": self.user.uid,
            "title": title,
            "likes": 0
        ] as [String : Any]
        
        postRef.setValue(json)
        
        self.ref.child("users").child(self.user.uid).child("posts").child(postId).setValue(true)
        self.titleTextField.resignFirstResponder()
    }
    
    func storePhotoPost(photo: UIImage, collectionId: String) {
        let userCollectionRef: FIRDatabaseReference = self.ref.child("users").child(self.user.uid).child("collections").child("posts").child(collectionId)
        userCollectionRef.setValue(true)
        
        let data: Data = UIImagePNGRepresentation(photo)!
        let dataRef = self.storageRef.child(self.user.uid).child("posts").child("\(collectionId).png")
        let uploadTask = dataRef.put(data)
        
        uploadTask.observe(.resume) { (snapshot) in
            print("the picture is being uploaded")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("the file has been uploaded")
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            print("something went wrong in the upload")
        }
        
        self.performSegue(withIdentifier: "unwindPost", sender: self)
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func post(photo: UIImage, collection: String) {
        let collectionRef: FIRDatabaseReference = self.ref.child("collections").child(collection).childByAutoId()
        collectionRef.setValue(["uid": self.user.uid, "username": self.user.username])
        let collectionId: String = collectionRef.key
        
        let userCollectionRef: FIRDatabaseReference = self.ref.child("users").child(self.user.uid).child("collections").child(collection).child(collectionId)
        userCollectionRef.setValue(true)
        
        let data: Data = UIImagePNGRepresentation(photo)!
        let dataRef = self.storageRef.child(self.user.uid).child(collection).child("\(collectionId).png")
        let uploadTask = dataRef.put(data)
        
        uploadTask.observe(.resume) { (snapshot) in
            print("the picture is being uploaded")
        }
        
        uploadTask.observe(.success) { (snapshot) in
            print("the file has been uploaded")
        }
        
        uploadTask.observe(.failure) { (snapshot) in
            print("something went wrong in the upload")
            collectionRef.removeValue()
            userCollectionRef.removeValue()
        }
        
        self.performSegue(withIdentifier: "unwindPost", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindPost" {
            let vc = segue.destination as! CameraViewController
            vc.setPhotosTaken(photos: [UIImage]())
        }
    }
}
