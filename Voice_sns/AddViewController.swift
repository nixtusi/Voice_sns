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
    
    var audioPlayer: AVAudioPlayer?
    //　Storageを使うときに初期化するやつ
    let storageRef = Storage.storage().reference()
    
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
        
        // ログイン情報を取得
        auth = Auth.auth()
        
        user = self.auth.currentUser
        me = AppUser(data: ["userID": user.uid])
    }
    
    @IBAction func postContent() {
        
        let fileName = "audio/" + UUID().uuidString + ".mp3"
        
        //Storageのaudio/correct.mp3という住所を指定
        let audioRef = storageRef.child(fileName)
        //ファイルを保存するときの設定
        let newMetadata = StorageMetadata()
        //音声ファイルですよって意味
        newMetadata.contentType = "audio/mpeg";
        //コンテンツを読み込んでいる
        let data = try! Data(contentsOf: audioRecorder.getURL())
        //DATAをアップロード
        let uploadTask = audioRef.putData(data, metadata: newMetadata) { metadata,
                                                                         error in
            if let metadata = metadata {
                print(metadata)
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
        
        let saveDocument = Firestore.firestore().collection("posts").document()
        saveDocument.setData([
            "content": fileName,
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
}
