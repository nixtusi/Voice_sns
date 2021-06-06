//
//  AddViewController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/06/06.
//
import UIKit
import Firebase

class AddViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!

    var me: AppUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 枠のカラー
        contentTextView.layer.borderColor = UIColor.black.cgColor

        // 枠の幅
        contentTextView.layer.borderWidth = 1.0

        // 枠を角丸にする
        contentTextView.layer.cornerRadius = 20.0
        contentTextView.layer.masksToBounds = true
    }
    
    @IBAction func postContent() {
        let content = contentTextView.text!
            let saveDocument = Firestore.firestore().collection("posts").document()
            saveDocument.setData([
                "content": content,
                "postID": saveDocument.documentID,
                "senderID": me.userID,
                "createdAt": FieldValue.serverTimestamp(),
                "updatedAt": FieldValue.serverTimestamp()
            ]) { error in
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    func setupTextView() {
        let toolBar = UIToolbar() // キーボードの上に置くツールバーの生成
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // 今回は、右端にDoneボタンを置きたいので、左に空白を入れる
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard)) // Doneボタン
        toolBar.items = [flexibleSpaceBarButton, doneButton] // ツールバーにボタンを配置
        toolBar.sizeToFit()
        contentTextView.inputAccessoryView = toolBar
    }

    // キーボードを閉じる処理。
    @objc func dismissKeyboard() {
        contentTextView.resignFirstResponder()
    }
    
    
}
