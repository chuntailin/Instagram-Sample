//
//  Post.swift
//  Instagram
//
//  Created by Chun Tie Lin on 2016/7/28.
//  Copyright © 2016年 Chun Tai. All rights reserved.
//

import Foundation
import Firebase

class Post {
    
    private var _postKey: String!
    private var _profileImgURL: String!
    private var _username: String!
    private var _description: String!
    private var _articleImgURL: String!
    private var _like: Int!
    
    var postKey: String {
        return _postKey
    }
    
    var profileImgURL: String {
        return _profileImgURL
    }
    
    var username: String {
        return _username
    }
    
    var description: String {
        return _description
    }
    
    var articleImgURL: String {
        return _articleImgURL
    }
    
    var like: Int {
        return _like
    }
    
    init(key: String, dictionary: [String:AnyObject]) {
        self._postKey = key
        
        if let profileImg = dictionary["profileImgURL"] as? String {
            self._profileImgURL = profileImg
        }
        
        if let name = dictionary["username"] as? String {
            self._username = name
        }
        
        if let content = dictionary["description"] as? String {
            self._description = content
        }
        
        if let articleImg = dictionary["acticleImgURL"] as? String {
            self._articleImgURL = articleImg
        }
        
        if let vote = dictionary["like"] as? Int {
            self._like = vote
        }
    }
    
}