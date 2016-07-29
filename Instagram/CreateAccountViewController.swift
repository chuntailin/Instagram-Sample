//
//  CreateAccountViewController.swift
//  Instagram
//
//  Created by Chun Tie Lin on 2016/7/28.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Firebase

class CreateAccountViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var uploadButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var pickedImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadPhotoTapped(sender: AnyObject) {
        
        //讓使用者進入相簿挑選照片
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func DoneTapped(sender: AnyObject) {
        
        let email = emailTextField.text
        let password = passwordTextField.text
        let username = usernameTextField.text
        
        if email != "" && password != "" && username != "" && pickedImage != nil {
            //創建使用者
            FIRAuth.auth()?.createUserWithEmail(email!, password: password!, completion: { (user, error) in
                if error != nil {
                    self.presentErrorView("Oops!", message: "Having some trouble to create your account")
                } else {
                    FIREmailPasswordAuthProvider.credentialWithEmail(email!, password: password!)
                    
                    //上傳照片到storage並創建user node
                    self.uploadImageToFirebase(self.pickedImage, completion: { [weak self](URL) in
                        let imgURL = URL
                        let userInfo = ["provider":(user?.providerID)!, "email":email!, "username":username!, "imgURL":imgURL]
                        DataService.dataservice.createUser((user?.uid)!, user: userInfo)
                        
                        //創建完使用者後直接登入
                        FIRAuth.auth()?.signInWithEmail(email!, password: password!, completion: { (user, error) in
                            if error != nil {
                                self!.presentErrorView("Oops!", message: "Having some trouble to sign in")
                            } else {
                                NSUserDefaults.standardUserDefaults().setObject(user?.uid, forKey: "uid")
                                self!.performSegueWithIdentifier("LoginWithCreate", sender: self)
                            }
                        })
                        })
                    
                }
            })
        } else {
            self.presentErrorView("Error", message: "Don't forget to enter email and password!")
        }
    }
    
    
    // MARK: - ImagePick
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.pickedImage = image
        self.profileImg.image = image
        self.uploadButton.hidden = true
        self.profileImg.hidden = false
        
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UploadImageToFirebase
    
    func uploadImageToFirebase(image: UIImage, completion:(URL: String) -> Void) {
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)
        var imgURL: String?
        
        DataService.dataservice.PROFILE_IMG_REF.putData(imgData!, metadata: nil) { (metaData, error) in
            if error != nil {
                self.presentErrorView("Oop!", message: "Have Somthing Trouble To Upload Photo")
            } else {
                imgURL = metaData?.downloadURL()?.absoluteString
                completion(URL: imgURL!)
            }
        }
    }

    
    // MARK: - AlerViewController
    
    func presentErrorView(title: String, message: String) {
        
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
