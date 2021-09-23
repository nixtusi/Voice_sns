//
//  PostCollectionViewCell.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/08/22.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {
    
    //サムネ
    @IBOutlet var thumbnailImageView: UIImageView!
    
    //ユーザー名
    @IBOutlet var userNameLabel: UILabel!
    
    //説明
    @IBOutlet var descriptionLabel: UITextView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 3
        layer.borderColor = UIColor.blue.cgColor
        layer.borderWidth = 3
        
    }
    
    func configure(imageData: Data?, userName: String, description: String) {
        if let data = imageData {
            thumbnailImageView.image = UIImage(data: data)
        } else {
            thumbnailImageView.image = UIImage(systemName: "music.note")
        }
        
        userNameLabel.text = userName
        descriptionLabel.text = description
    }

}
