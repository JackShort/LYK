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

class NFViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var storage: FIRStorage!
    var storageRef: FIRStorageReference!
    var ref: FIRDatabaseReference!
    var currentUser: FIRUser!
    var user: User!
    var userLoaded: Bool = false
    
    var photosData: [String: [String: AnyObject]]!
    var postIds: [String]!
    
    var photosToUse: [UIImage]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.currentUser = FIRAuth.auth()?.currentUser!
        self.storage = FIRStorage.storage()
        self.storageRef = self.storage.reference()
        self.ref = FIRDatabase.database().reference()
        
        self.postIds = []
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
        
        //collectionView Shit
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // load the shit if able
        if userLoaded {
            self.load()
        }
    }
    
    func setUserLoaded(b: Bool) {
        self.userLoaded = b
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
                
                print("we retrieved basic data and fetching photos")
                
                self.photosData[postId] = data
                self.postIds.append(postId)
                self.getPhotos(photos: photos, uid: uid, postId: postId)
                
//                self.tableView.reloadData()
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
//                        self.tableView.reloadData()
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
    
    //    func getImage(photoData: NSDictionary, photoId: String) {
    //        let uid = photoData["uid"] as! String
    //        let username = photoData["username"] as! String
    //        let title = photoData["title"] as! String
    //        let photoPath = self.storageRef.child(uid).child(photoId + ".png")
    //        photoPath.data(withMaxSize: 10 * 1024 * 1024) { (data, error) in
    //            if let error = error {
    //                print("uh oh error when downloading photo")
    //                print(error.localizedDescription)
    //            } else {
    //                let downloadedImage = UIImage(data: data!)
    //                let imageRef = downloadedImage?.cgImage
    //                let image = UIImage(cgImage: imageRef!, scale: 1.0, orientation: UIImageOrientation.right)
    //
    //                self.photoIds?.append(photoId)
    //                self.photosData?[photoId] = [
    //                    "photo": image,
    //                    "uid": uid as AnyObject,
    //                    "username": username as AnyObject,
    //                    "title": title as AnyObject
    //                ]
    //
    //                self.tableView.reloadData()
    //            }
    //        }
    //    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.fade
    }
    
    
    
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NFPostCell") as! NFPostCell
//        let postId = self.postIds[indexPath.row]
//        let postData = self.photosData[postId]!
//        
//        let username = postData["username"] as! String
//        let uid = postData["uid"] as! String
//        let title = postData["title"] as! String
//        let hasLoaded = postData["hasLoadedPhotos"] as! Bool
//        
//        cell.setUsernameLabel(name: username)
//        cell.titleLabel.text = title
//        
//        if hasLoaded {
//            let photos = postData["photos"] as! [UIImage]
//            cell.setPhotos(photos: photos)
//        }
//        
//        return cell
    
//        
//        let cell = tableView.cellForRow(at: indexPath) as! NFPostCell
//        self.photosToUse = cell.photos
//        
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NFPostCell", for: indexPath)
        cell.backgroundColor = UIColor.black
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SwipeCardViewController
        vc.photos = self.photosToUse
    }
    
    //style shit
}
