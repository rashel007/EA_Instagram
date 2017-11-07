//
//  UploadViewController.swift
//  EA_Instagram
//
//  Created by Estique on 11/4/17.
//  Copyright © 2017 Estique. All rights reserved.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var previewImageView: UIImageView!
    
    @IBOutlet var selectBtn: UIButton!
    
    @IBOutlet var postBtn: UIButton!
    
    let indicator = ShowIndicator()
    
    var picker = UIImagePickerController()
    
    let imageUploadManager = ImageUploadManager()
    

    override func viewDidLoad() {
        super.viewDidLoad()

       picker.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backToUser" {
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            self.previewImageView.isHidden = false
            
            self.previewImageView.image = image
        
            self.selectBtn.isHidden = true
            self.postBtn.isHidden = false
        
        }
        
         self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func postBtnPressed(_ sender: Any) {
        
        let uid = Auth.auth().currentUser!.uid
        
        let ref =  Database.database().reference()
        
        let key = ref.child("posts").childByAutoId().key
        
        self.indicator.customActivityIndicatory(self.view, startAnimate: true)
        
        imageUploadManager.uploadImagePosts(self.previewImageView.image!) { (url, error) in
           
            
            if error != nil {
                print(error!)
                AppDelegate.instance().dismissActivityIndicator()
                return
            }
            
            if let url = url {
                let feed = [
                    "userID" : uid,
                    "pathToImage" : url.absoluteString,
                    "likes" : 0,
                    "author" : Auth.auth().currentUser!.displayName!,
                    "postID" : key
                ] as [String : Any]
                
                let postFeed = ["\(key)" : feed]
                
                ref.child("posts").updateChildValues(postFeed)
               self.indicator.customActivityIndicatory(self.view, startAnimate: false)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        
        
    }

    @IBAction func selectBtnPressed(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
        
        
    }

}
