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
    private var _IMG_REF: FIRStorageReference
    
    var BASE_REF: FIRDatabaseReference {
        return _BASE_REF
    }
    
    var USER_REF: FIRDatabaseReference {
        return _USER_REF
    }
    
    var POSR_REF: FIRDatabaseReference {
        return _POST_REF
    }
    
    var BASE_STORAGE_REF: FIRStorageReference {
        return _BASE_STORAGE_REF
    }
    
    var IMG_REF: FIRStorageReference {
        return _IMG_REF
    }
    
    init() {
        self._BASE_REF = FIRDatabase.database().reference()
        self._USER_REF = _BASE_REF.child("users")
        self._POST_REF = _BASE_REF.child("posts")
        self._BASE_STORAGE_REF = FIRStorage.storage().reference()
        self._IMG_REF = _BASE_STORAGE_REF.child("images")
    }
    
    func createUser(uid: String, user: [String:String]){
        USER_REF.child(uid).updateChildValues(user)
    }

    func createPost(post: [String:AnyObject]) {
        let newPostNode = POSR_REF.childByAutoId()
        newPostNode.updateChildValues(post)
    }
}