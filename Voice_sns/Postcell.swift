//
//  Postcell.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/07/18.
//

import Foundation
import Foundation

class PostCell : NSObject {
  var userName: String
  var contents: String

  init(userName: String, contents: String){
    self.userName = userName
    self.contents = contents
  }
}
