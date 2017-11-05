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
    
    var indicator = ShowIndicator()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       print("viewDidLoad")
  
    
        // Do any additional setup after loading the view.
    }
    
    override func performSegue(withIdentifier identifier: String, sender: Any?) {
      print(identifier)
    }
    
    
    @IBAction func btnLogin(_ sender: Any) {
        guard email.text != "", password.text != "" else {
            print("Email or Password Empty")
            return
        }
        
          print("Login button clicked")
       self.indicator.customActivityIndicatory(self.view, startAnimate: true)
        
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let user = user {
                let vc  = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
              self.indicator.customActivityIndicatory(self.view, startAnimate: false)
                self.present(vc, animated: true, completion: nil)
                
            }
        }
        
        
    }

    @IBAction func btnSignup(_ sender: Any) {
        
    }

}
