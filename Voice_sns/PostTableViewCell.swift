//
//  PostTableViewCell.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/07/18.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    @IBOutlet var userName: UILabel!
    @IBOutlet var contents: UILabel!
    
    @IBOutlet var postImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(post: Post) {
        self.userName.text = post.userName
        self.contents.text = post.description
      }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
