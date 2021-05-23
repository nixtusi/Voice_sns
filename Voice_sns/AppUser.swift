//
//  AppUser.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/05/23.
//

import Foundation
import Firebase

struct AppUser {
    let userID: String
    let userName: String
    
    init(data: [String: Any]) {
        userID = data["userID"] as! String
        userName = data["userName"] as? String ?? "匿名"
    }
}
