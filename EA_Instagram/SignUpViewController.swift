//
//  SignUpViewController.swift
//  EA_Instagram
//
//  Created by Estique on 10/27/17.
//  Copyright © 2017 Estique. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var fullname: UITextField!
    
    @IBOutlet var email: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet var confirmPAssword: UITextField!
    
    @IBOutlet var imageview: UIImageView!
    
    @IBOutlet var btnNextOutlet: UIButton!
    
    let picker = UIImagePickerController()
    
    
    let imageUploadManager = ImageUploadManager()
    

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        picker.delegate = self
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "backLogin" {
            print("segue happend")
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    @IBAction func btnNextAction(_ sender: Any) {
        
        guard fullname.text != "", email.text != "", password.text != "", confirmPAssword.text != "" else {
            print("Field is empty")
            return
        }
        
        if password.text == confirmPAssword.text {
            
        Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = user {
                
                let changRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                changRequest.displayName = self.fullname.text
                changRequest.commitChanges(completion: nil)
            
                print(" Sign UP -> \(user.uid)")
                
//                spaceRef = self.storage.reference(forURL: "gs://eainstagram-53698.appspot.com")
                
                self.imageUploadManager.uploadImage(self.imageview.image!, user.uid + ".jgp", completionBack: { (url, error) in
                    if error != nil {
                        print(error ?? "Error")
                    }
                    
                    print(url?.relativeString ?? "URL")
                    
                    if let url = url?.relativeString {
                        
                        let userInfo: [String : Any] = ["uid" : user.uid,
                                                        "fullname" : self.fullname.text!,
                                                        "urlToImage" : url]
            
                        
                        Database.database().reference().child("users").child(user.uid).setValue(userInfo)
                        
//                        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
//                        self.present(vc, animated: true, completion: nil)
                        self.dismiss(animated: true, completion: nil)
                    }
                    
                })
        
            }
        })
        
            
            
        } else {
            print("Passwprd not matched !")
        }
        
    }
    
    @IBAction func selectImage(_ sender: Any) {
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            self.imageview.image = image
            btnNextOutlet.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
    }



}
