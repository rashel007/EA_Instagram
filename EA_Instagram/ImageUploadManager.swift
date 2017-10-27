//
//  ImageUploadManager.swift
//  EA_Instagram
//
//  Created by Estique on 10/28/17.
//  Copyright © 2017 Estique. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase

class ImageUploadManager: NSObject {
    
    func uploadImage (_ image: UIImage, _ imagename: String, completionBack: @escaping (_ url: URL?, _ errorMessage: String?) -> Void){
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        //create referance
        let imageRef = storageRef.child("users").child(imagename)
        
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            
            let uploadTask = imageRef.putData(imageData, metadata: metadata, completion: { (metadata, error) in
                if let metadata = metadata {
                    completionBack(metadata.downloadURL(), nil)
                }else {
                    completionBack(nil, error?.localizedDescription)
                }
            })
            
            uploadTask.resume()
            
        } else {
            completionBack(nil, "Image couldn't be converted to Data")
        }
    }

}
