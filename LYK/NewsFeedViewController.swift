//
//  NewsFeedViewController.swift
//  LYK
//
//  Created by Jack Short on 1/16/17.
//  Copyright © 2017 Jack Short. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SDWebImage

class NewsFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!
    
    var storage: FIRStorage!
    var storageRef: FIRStorageReference!
    var ref: FIRDatabaseReference!
    var currentUser: FIRUser!
    var user: User!
    //implement this
    var userLoaded: Bool = false
    
    var photosData: [String: [String: AnyObject]]!
    var photoIds: [String]!
    
    var photoToUse: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = FIRAuth.auth()?.currentUser!
        self.storage = FIRStorage.storage()
        self.storageRef = self.storage.reference()
        self.ref = FIRDatabase.database().reference()
        
        self.photoIds = []
        self.photosData = [String: [String: AnyObject]]()
        
//        let dataRef = self.storageRef.child(self.currentUser.uid).child("test").child("test.png")
//        dataRef.downloadURL { (url, error) in
//            if let error = error {
//                print("there was an error downloading the url")
//            } else {
//                print("should have downloaded this shit")
//                self.testImageView.sd_setImage(with: url)
//            }
//        }
        
        //table view shit
        self.tableView.register(NFPostCell.classForCoder(), forCellReuseIdentifier: "NFPostCell")
        self.tableView.register(UINib(nibName: "NFPostCell", bundle: nil), forCellReuseIdentifier: "NFPostCell")
        
        //navigation bar shit
        self.navigationController?.navigationBar.barTintColor = UIColor.flatMint()
        self.navigationController?.navigationBar.tintColor = UIColor.flatWhite()
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.flatWhite()]
        self.title = "LYK"
        
        // load data
        self.load()
    }
    
    func load() {
//        let myPhotosRef = ref.child("users").child(self.currentUser.uid).child("photos")
//        myPhotosRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            let photosDict = snapshot.value as? NSDictionary
//            let photos = photosDict?.allKeys as? [String]
//            
//            guard photos != nil else {
//                return
//            }
//            
//            for photoId in photos! {
//                self.getPhotos(photoId: photoId)
//            }
//        })
        
        for friend in self.user.friends{
            self.ref.child("posts").queryOrdered(byChild: friend).observeSingleEvent(of: .value, with: { (snapshot) in
                var value = snapshot.value as! NSDictionary
                let postId = value.allKeys[0] as! String
                value = value[postId] as! NSDictionary
                
                let username = value["username"] as! String
                let title = value["title"] as! String
                let uid = value["uid"] as! String
                let photos = value["photos"] as! [String]
                
                let data = [
                    "photos": [UIImage]() as AnyObject,
                    "username": username as AnyObject,
                    "title": title as AnyObject,
                    "uid": uid as AnyObject,
                    "hasLoadedPhotos": false as AnyObject
                    ] as [String : AnyObject]
                
                self.photosData[postId] = data
                self.getPhotos(photos: photos, uid: uid, postId: postId)
            })
        }
    }
    
    func getPhotos(photos: [String], uid: String, postId: String) {
        let capPhotos: Int = photos.count
        var counter: Int = 0
        
        for photo in photos {
            let photoPath = self.storageRef.child(uid).child("posts").child(photo + ".png")
            
            photoPath.data(withMaxSize: 10 * 1024 * 1024) { (data, error) in
                if let error = error {
                    print("uh oh error when downloading photo")
                    print(error.localizedDescription)
                } else {
                    let downloadedImage = UIImage(data: data!)
                    let imageRef = downloadedImage?.cgImage
                    let image = UIImage(cgImage: imageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                    
                    var photoArr = self.photosData[postId]?["photos"] as! [UIImage]
                    photoArr.append(image)
                    self.photosData[postId]?["photos"] = photoArr as AnyObject
                    
                    counter += 1
                    
                    if counter == capPhotos {
                        self.photosData[postId]?["hasLoadedPhotos"] = true as AnyObject
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
    }
 
//    func getPhotos(photoId: String) {
//        let photoRef = self.ref.child("photos").child(photoId)
//        photoRef.observeSingleEvent(of: .value, with: { (snapshot) in
//            let value = snapshot.value as? NSDictionary
//
//            self.getImage(photoData: value!, photoId: photoId)
//            print("fetching photo...")
//        })
//    }
    
    func getImage(photoData: NSDictionary, photoId: String) {
        let uid = photoData["uid"] as! String
        let username = photoData["username"] as! String
        let title = photoData["title"] as! String
        let photoPath = self.storageRef.child(uid).child(photoId + ".png")
        photoPath.data(withMaxSize: 10 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("uh oh error when downloading photo")
                print(error.localizedDescription)
            } else {
                let downloadedImage = UIImage(data: data!)
                let imageRef = downloadedImage?.cgImage
                let image = UIImage(cgImage: imageRef!, scale: 1.0, orientation: UIImageOrientation.right)
                
                self.photoIds?.append(photoId)
                self.photosData?[photoId] = [
                    "photo": image,
                    "uid": uid as AnyObject,
                    "username": username as AnyObject,
                    "title": title as AnyObject
                ]
                
                self.tableView.reloadData()
            }
        }
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.photosData.keys.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NFPostCell") as! NFPostCell
        let photoId = self.photoIds[indexPath.row]
        let photoData = self.photosData[photoId]!
        
        let username = photoData["username"] as! String
        let uid = photoData["uid"] as! String
        let photo = photoData["photo"] as! UIImage
        let title = photoData["title"] as! String
        
        cell.setUsernameLabel(name: username)
        cell.previewImageView.image = photo
        cell.titleLabel.text = title
        cell.setPhoto(photo: photo)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: false)
        
        let cell = tableView.cellForRow(at: indexPath) as! NFPostCell
        self.photoToUse = cell.photo
        
        self.performSegue(withIdentifier: "showSwipeCards", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SwipeCardViewController
        vc.image = self.photoToUse
    }
}
