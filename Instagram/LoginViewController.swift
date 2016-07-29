//
//  LoginViewController.swift
//  Instagram
//
//  Created by Chun Tai on 2016/7/28.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginTapped(sender: AnyObject) {
        
        let email = emailTextField.text!
        let password = passwordTextField.text!
        
        if email != "" && password != "" {
            FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
                if error != nil {
                    self.presentAlertView("Oops!", message: "Have Something Trouble To Sign In")
                } else {
                    NSUserDefaults.standardUserDefaults().setObject(user?.uid, forKey: "uid")
                    self.performSegueWithIdentifier("Login", sender: nil)
                }
            })
        } else {
            self.presentAlertView("Oops!", message: "Please Enter Email and Password")
        }
    }

    func presentAlertView(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertVC.addAction(action)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
