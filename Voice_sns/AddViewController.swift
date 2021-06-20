//
//  AddViewController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/06/06.
//
import UIKit
import Firebase
import AVFoundation

class AddViewController: UIViewController {
    
    @IBOutlet var contentTextView: UITextView!
    // 録音しているかどうか
    var isRecording = false
    
    var isPlaying = false

    var me: AppUser!
    var user: User!
    var auth: Auth!
    
    let audioRecorder = AudioRecorder()
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 枠のカラー
        contentTextView.layer.borderColor = UIColor.black.cgColor

        // 枠の幅
        contentTextView.layer.borderWidth = 1.0

        // 枠を角丸にする
        contentTextView.layer.cornerRadius = 20.0
        contentTextView.layer.masksToBounds = true
        
        // ログイン情報を取得
        auth = Auth.auth()
        
        user = self.auth.currentUser
        me = AppUser(data: ["userID": user.uid])
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
    
    @IBAction func closeModal() {
        self.dismiss(animated: true, completion: nil)
    }

    func setupTextView() {
        let toolBar = UIToolbar() // キーボードの上に置くツールバーの生成
        let flexibleSpaceBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil) // 今回は、右端にDoneボタンを置きたいので、左に空白を入れる
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard)) // Doneボタン
        toolBar.items = [flexibleSpaceBarButton, doneButton] // ツールバーにボタンを配置
        toolBar.sizeToFit()
        contentTextView.inputAccessoryView = toolBar
    }
    
    @IBAction func onRecordButtonClicked() {
        // falseのときtrue, trueのときfalse
        isRecording = !isRecording
        print(isRecording)
        
        if isRecording == true {
            //録音開始
            self.audioRecorder.record()
            
            let picture = UIImage(systemName: "record.circle.fill")
            self.recordButton.setImage(picture, for: .normal)
            
        } else {
            //録音停止
            _ = self.audioRecorder.recoredStop()
            
            let picture = UIImage(systemName: "record.circle")
            self.recordButton.setImage(picture, for: .normal)
        }
        
    }
    
    @IBAction func onPlayButtonClicked() {
        isPlaying = !isPlaying
        
        if isPlaying == true {
            self.audioRecorder.play()
            
            let picture = UIImage(systemName: "pause")
            self.playButton.setImage(picture, for: .normal)
            
        } else {
            self.audioRecorder.playStop()
            
            let picture = UIImage(systemName: "play")
            self.playButton.setImage(picture, for: .normal)
        }
    }

    // キーボードを閉じる処理。
    @objc func dismissKeyboard() {
        contentTextView.resignFirstResponder()
    }
    
    
}
