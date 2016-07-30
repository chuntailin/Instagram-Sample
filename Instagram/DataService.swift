//
//  DataService.swift
//  Instagram
//
//  Created by Chun Tie Lin on 2016/7/28.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    
    static let dataservice = DataService()
    
    private var _BASE_REF: FIRDatabaseReference
    private var _USER_REF: FIRDatabaseReference
    private var _POST_REF: FIRDatabaseReference
    private var _BASE_STORAGE_REF: FIRStorageReference
    private var _PROFILE_IMG_REF: FIRStorageReference
    private var _POST_IMG_REF: FIRStorageReference
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    
    var POST_REF: FIRDatabaseReference {
        return _POST_REF
    }
    
    var CURRENT_USER: FIRDatabaseReference {
        let uid = NSUserDefaults.standardUserDefaults().objectForKey("uid") as! String
        let currentUser = _USER_REF.child(uid)
        return currentUser
    }
    
    
    var BASE_STORAGE_REF: FIRStorageReference {
        return _BASE_STORAGE_REF
    }
    
    var PROFILE_IMG_REF: FIRStorageReference {
        return _PROFILE_IMG_REF
    }
    
    var POST_IMG_REF: FIRStorageReference {
        return _POST_IMG_REF
    }
    
    init() {
        self._BASE_REF = FIRDatabase.database().reference()
        self._USER_REF = _BASE_REF.child("users")
        self._POST_REF = _BASE_REF.child("posts")
        self._BASE_STORAGE_REF = FIRStorage.storage().reference()
        self._PROFILE_IMG_REF = _BASE_STORAGE_REF.child("profileImages")
        self._POST_IMG_REF = _BASE_STORAGE_REF.child("postImages")
    }
    
    func createUser(uid: String, user: [String:String]){
        USER_REF.child(uid).updateChildValues(user)
    }

    func createPost(post: [String:AnyObject]) {
        let newPostNode = POST_REF.childByAutoId()
        newPostNode.updateChildValues(post)
    }
}