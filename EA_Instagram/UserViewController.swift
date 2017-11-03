//
//  UserViewController.swift
//  EA_Instagram
//
//  Created by Estique on 10/30/17.
//  Copyright © 2017 Estique. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var user = [User]()
    
    //set the name of logged in user
    @IBOutlet var userName: UIBarButtonItem!
    
    var ref: DatabaseReference!
    
    
    @IBAction func logout(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        
        getUser()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "usersCell", for: indexPath) as! UsersTableViewCell
        
        cell.fullname.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].userID
        
        cell.userIMage.downloadImage(from: self.user[indexPath.row].imagePath)
        
        checkForFollowing(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userID = Auth.auth().currentUser?.uid
        print("USER ID :  \(userID)")
        
        let key = ref.child("users").childByAutoId().key
        
        var isFollower = false
        
        
        ref.child("users").child(userID!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let following = snapshot.value as? [String : AnyObject] {
                
                for (ke, value) in following {
                    if value as! String == self.user[indexPath.row].userID {
                        isFollower = true
                        
                        self.ref.child("users").child(userID!).child("following/\(ke)").removeValue()
                        self.ref.child("users").child(self.user[indexPath.row].userID).child("followers/\(ke)").removeValue()
                        
                        //unchecking table view row
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
            }
            
            if !isFollower {
                let following = ["following/\(key)" : self.user[indexPath.row].userID]
                let followers = ["followers/\(key)" : userID]
                
                self.ref.child("users").child(userID!).updateChildValues(following)
                self.ref.child("users").child(self.user[indexPath.row].userID).updateChildValues(followers)
                
                self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
            
            self.ref.removeAllObservers()
            
            
        })
    }
    
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToLogin" {
            print("User VC dismissed")
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func getUser(){
        let userID = Auth.auth().currentUser?.uid
        print(userID ?? "No User ID Found")
        
 
            ref.child("users").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                
                if  let data = snapshot.value as? [String : AnyObject] {
                
                    //remove all user 
                    self.user.removeAll()
                    
                    print( "User number\(data.count)")
                    
                    for (_, value) in data {
                        if let uid = value["uid"] as? String {
                            
                            if uid == userID {
                                
                                let name = value["fullname"] as? String;
                                
                                if name != nil {
                                    var splitNameBySpace = name?.components(separatedBy: " ")
                                    
                                    if let title = splitNameBySpace?[0] {
    
                                        if  let item = self.navigationItem.rightBarButtonItem {
                                            let button = item.customView as! UIButton
                                            button.setTitle(title, for: .normal)
                                        }
                                    }
                                    
                                }
                          
                            }
                            
                            if uid != userID {
    
                                
                                let userToShow = User()
                                
                                if let fullName = value["fullname"] as? String, let imagePath = value["urlToImage"] as? String {
                                    
                                    userToShow.fullName = fullName
                                    userToShow.imagePath = imagePath
                                    userToShow.userID = uid
                                    
                                    self.user.append(userToShow)
                               
                                    
                                }
                                
                                
                                
                            }
                        }
                    }
                    
                         self.tableView.reloadData()
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
    
        
    
        
        
    }
    
    
    func checkForFollowing(indexPath: IndexPath){
            let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let following = snapshot.value as? [String : AnyObject] {
                
                for (_ , value) in following {
                    
                    if value as! String == self.user[indexPath.row].userID {
                        
                        self.tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                }
            }
        })
        
        ref.removeAllObservers()
    }


}

extension UIImageView {
    
    func downloadImage(from imgURl: String!) {
        let url = URLRequest(url: URL(string: imgURl)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            if error != nil {
                print(error!.localizedDescription)
                return
            }
            
            
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
            
            
            
        }
        
        task.resume()
    }
    
    
}
