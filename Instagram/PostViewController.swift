//
//  PostViewController.swift
//  Instagram
//
//  Created by Chun Tai on 2016/7/28.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var articleImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var pickedImage: UIImage?
    var profileImageURL: String?
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentTextView.text = "Type something here ..."
        self.contentTextView.textColor = UIColor.whiteColor()
        
        getUserInfo()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func uploadImageTapGesture(sender: AnyObject) {
        print("Tapped")
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.allowsEditing = false
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
        }

    }
    
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        
        let content = contentTextView.text
        
        if content != "" && pickedImage != nil {
            self.uploadPhotoToFirebase(pickedImage!, completion: { (URL) in
                let imgURL = URL
                let post = ["profileImgURL":self.profileImageURL!, "username":self.username!, "description": content, "articleImgURL":imgURL, "like":0]
                DataService.dataservice.createPost(post as! [String : AnyObject])
            })
            self.presentSuccessView("Congratulation!", message: "You have successfully post!")
        }
    }
    
    func getUserInfo() {
        DataService.dataservice.CURRENT_USER.observeEventType(.Value) { (snapshot: FIRDataSnapshot) in
            self.profileImageURL = snapshot.value?.objectForKey("imgURL") as? String
            self.username = snapshot.value?.objectForKey("username") as? String
        }
    }
    
    // MARK : - TextView
    
    func textViewDidBeginEditing(textView: UITextView) {
        if self.contentTextView.text != "" {
            self.contentTextView.text = ""
            self.contentTextView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if self.contentTextView.text == "" {
            self.contentTextView.text = "Type something here ..."
            self.contentTextView.textColor = UIColor.whiteColor()
        }
    }
    
    
    // MARK: - ImagePick
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        self.articleImage.image = image
        self.pickedImage = image
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    // MARK: - UploadPhotoToFirebase
    
    func uploadPhotoToFirebase(image: UIImage, completion:(URL: String) -> Void){
        
        let imgData = UIImageJPEGRepresentation(image, 0.2)
        let currentTime = "\(NSDate.timeIntervalSinceReferenceDate())"
        var imgURL: String!
        
        DataService.dataservice.POST_IMG_REF.child(currentTime).putData(imgData!, metadata: nil) { (metaData, error) in
            if error != nil {
                self.presentErrorView("Oop!", message: "Have Somthing Trouble To Upload Photo")
            } else {
                imgURL = metaData?.downloadURL()?.absoluteString
                completion(URL: imgURL)
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
    
    
    func presentSuccessView(title: String, message: String) {
    
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default) { (action) in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let FeedVC = storyboard.instantiateViewControllerWithIdentifier("FeedViewController") as? FeedViewController
            self.presentViewController(FeedVC!, animated: true, completion: nil)
        }
        alertVC.addAction(action)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
}
