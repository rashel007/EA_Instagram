//
//  LogInViewController.swift
//  EA_Instagram
//
//  Created by Estique on 10/27/17.
//  Copyright © 2017 Estique. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {
    
    
    @IBOutlet var email: UITextField!

    @IBOutlet var password: UITextField!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        guard email.text != "", password.text != "" else {
            print("Email or Password Empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = user {
                let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        
        
    }

    @IBAction func btnSignup(_ sender: Any) {
        
    }

}
