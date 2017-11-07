//
//  FeedViewController.swift
//  EA_Instagram
//
//  Created by Estique on 11/6/17.
//  Copyright © 2017 Estique. All rights reserved.
//

import UIKit
import Firebase

class FeedViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var collectionView: UICollectionView!
    
    var feeds = [Feeds]()
    
    var following = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchFeeds()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToUser" {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func fetchFeeds() {
        let ref = Database.database().reference()
        
        ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let users = snapshot.value as! [String : AnyObject]
            
            for ( _, value) in users {
                if let userID = value["uid"] as? String {
                    if userID == Auth.auth().currentUser?.uid {
                        
                        if let followingUsers = value["follwoing"] as? [String : String] {
                            for (_, userPeoples) in followingUsers {
                                
                                self.following.append(userPeoples)
                                
                            }
                        }
                        
                        self.following.append(Auth.auth().currentUser!.uid)
                        
                        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                            
                            let feedsSnap = snapshot.value as! [String : AnyObject]
                            
                            for ( _, value) in feedsSnap {
                                if let userID = value["userID"] as? String {
                                    for each in self.following {
                                        if each == userID {
                                            
                                            let feed = Feeds()
                                            
                                            if let author = value["author"] as? String, let likes = value["likes"] as? Int,
                                            let pathToImage = value["pathToImage"] as? String, let postID = value["postID"]
                                                as? String {
                                                
                                                feed.authod = author
                                                feed.likes = likes
                                                feed.pathToImage = pathToImage
                                                feed.postID = postID
                                                feed.userID = userID
                                                
                                                self.feeds.append(feed)
                                            }
                                        }
                                    }
                                    
                                    self.collectionView.reloadData()
                                }
                            }
                            
                        })
                        
                    }
                }
            }
            
        })
        
        ref.removeAllObservers()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.feeds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FeedsCell
        
        
        cell.image.downloadImage(from: feeds[indexPath.row].pathToImage)
        cell.userName.text = feeds[indexPath.row].authod
        cell.likeCount.text = "\(feeds[indexPath.row].likes!) Likes"
        
        return cell
    }


}
