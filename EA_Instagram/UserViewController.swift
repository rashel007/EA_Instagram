//
//  UserViewController.swift
//  EA_Instagram
//
//  Created by Estique on 10/30/17.
//  Copyright © 2017 Estique. All rights reserved.
//

import UIKit
import Firebase

class UserViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    
    var user = [User]()
    
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
        
        
        return cell
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
                            if uid != userID {
                                print("User id matched")
                                
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
