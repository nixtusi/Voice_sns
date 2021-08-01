//
//  AddViewController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/06/06.
//
import UIKit
import Firebase
import AVFoundation

class AddViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var audioPlayer: AVAudioPlayer?
    //　Storageを使うときに初期化するやつ
    let storageRef = Storage.storage().reference()
    
    // 録音しているかどうか
    var isRecording = false
    
    var isPlaying = false
    
    var me: AppUser!
    var user: User!
    var auth: Auth!
    
    var descriptionString = ""
    
    let audioRecorder = AudioRecorder()
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet var postButton: UIButton!
    @IBOutlet var chancelButton: UIButton!
    
    @IBOutlet weak var verificationImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postButton.backgroundColor = UIColor.black // 背景色
        postButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        postButton.setTitleColor(UIColor.white,for: UIControl.State.normal) // タイトルの色
        
        descriptionTextView.layer.borderColor = UIColor.black.cgColor //枠線
        descriptionTextView.layer.borderWidth = 1.0 //枠線の太さ
        
//        chancelButton.backgroundColor = UIColor.black // 背景色
//        chancelButton.layer.cornerRadius = 10.0 // 角丸のサイズ
//        chancelButton.setTitleColor(UIColor.white,for: UIControl.State.normal) // タイトルの色
        
        // ログイン情報を取得
        auth = Auth.auth()
        
        user = self.auth.currentUser
        me = AppUser(data: ["userID": user.uid])
    }
    
//    func getFileData(_ filePath: String) -> Data? {
//        let fileData: Data?
//        do {
//            let fileUrl = URL(fileURLWithPath: filePath)
//            fileData = try Data(contentsOf: URL(fileURLWithPath: fileUrl))
//        } catch {
//            // ファイルデータの取得でエラーの場合
//            fileData = nil
//        }
//        return fileData
//    }
    
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
        
        
        //画像をアップロード
//        var photo = UIImage(named: "image99.png")?.pngData()
        var photo = verificationImage.image?.pngData()
        let photoName = "images/" + UUID().uuidString + ".jpg"
        let photoRef = storageRef.child(photoName)
        let photoMetadata = StorageMetadata()
        photoMetadata.contentType = "image/jpeg"
        
        //DATAをアップロード
        let photoUploadTask = photoRef.putData(photo!, metadata: photoMetadata) { metadata,
                                                                         error in
            if let metadata = metadata {
                print(metadata)
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
        
        //textfieldの内容取得
        descriptionString = descriptionTextView.text!
        descriptionTextView.text = ""
        
        let saveDocument = Firestore.firestore().collection("posts").document()
        saveDocument.setData([
            "content": fileName,
            "postID": saveDocument.documentID,
            "photoURL": photoName,
            "senderID": me.userID,
            "description": descriptionString,
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
    
    //画像選択
    @IBAction func choosephoto(_sender: Any){
        let pickerController = UIImagePickerController()
                
        //PhotoLibraryから画像を選択
        pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
         
        //デリゲートを設定する
        pickerController.delegate = self
                
        //ピッカーを表示する
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            // モーダルビュー（つまり、イメージピッカー）を閉じる
            dismiss(animated: true, completion: nil)
            
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                //ボタンの背景に選択した画像を設定
                verificationImage.image = image
            } else{
                print("Error")
            }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // モーダルビューを閉じる
        dismiss(animated: true, completion: nil)
    }
    
}
