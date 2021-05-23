//
//  Post.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/05/23.
//

import Foundation
import Firebase
import FirebaseFirestore

struct Post {
    let content: String
    let postID: String
    let senderID: String
    let createAt: Timestamp
    let updateAt: Timestamp
    
    init(data: [String: Any]) {
        content = data["content"] as! String
        postID = data["postID"] as! String
        senderID = data["senderID"] as! String
        createAt = data["createdAt"] as! Timestamp
        updateAt = data["updatedAt"] as! Timestamp
    }
    
}
