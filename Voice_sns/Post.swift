//
//  Post.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/05/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct Post {
    let content: String
    let postID: String
    let senderID: String
    let createAt: Timestamp
    let updateAt: Timestamp
    let userName: String
    let description: String
    let photoURL: String
    var thumbnailImage: UIImage?
    
    let storageRef = Storage.storage().reference()
    
    //
    init(data: [String: Any]) {
        content = data["content"] as! String
        postID = data["postID"] as! String
        senderID = data["senderID"] as! String
        createAt = data["createdAt"] as! Timestamp
        updateAt = data["updatedAt"] as! Timestamp
        userName = data["userName"] as? String ?? "匿名"
        description = data["description"] as? String ?? ""
        photoURL = data["photoURL"] as? String ?? ""
        
        //photoImage = data["photoImage"] as! UIImage
        
    }
    
//    mutating func loadThumbnail(){
//        let photoRef = self.storageRef.child(photoURL)
//        
//        if photoURL != "" {
//            photoRef.getData(maxSize: 30 * 1024 * 1024) { data, error in
//                if let error = error {
//                    print("error")
//                    print(error.localizedDescription)
//                } else {
//                    if let imageData = data {
//                        print("画像あああああ")
//                        self.thumbnailImage = UIImage(data: imageData)!
//                        
//                    } else {
//                        print("画像なし")
//                        self.thumbnailImage = UIImage(systemName: "music.note")!
//                    }
//                }
//            }
//            
//        }
//    }
    
}
