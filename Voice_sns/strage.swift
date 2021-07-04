//
//  strage.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/07/04.
//

import UIKit
import FirebaseStorage
import AVFoundation

class strage: UIViewController {
    var audioPlayer: AVAudioPlayer?
    //　Storageを使うときに初期化するやつ
    let storageRef = Storage.storage().reference()
    //ローカルのmp3ファイルを読み込み
    let testMP3File = Bundle.main.url(forResource: "001-sibutomo", withExtension: "mp3")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        //Storageのaudio/correct.mp3という住所を指定
        let audioRef = storageRef.child("audio/correct.mp3")
        //ファイルを保存するときの設定
        let newMetadata = StorageMetadata()
        //音声ファイルですよって意味
        newMetadata.contentType = "audio/mpeg";
        //testMP3fileのコンテンツを読み込んでいる
        let data = try! Data(contentsOf: testMP3File)
        //DATAをアップロード
        let uploadTask = audioRef.putData(data, metadata: newMetadata) { metadata,
            error in
            if let metadata = metadata {
                print(metadata)
            }
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            //データを取り出す
            audioRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
                if let error = error {
                    print("error")
                    print(error.localizedDescription)
                } else {
                    if let mp3Data = data {
                        do {
                            self.audioPlayer = try AVAudioPlayer(data: mp3Data)
                            print("correct")
                        } catch {
                            print("mp3Data error")
                            print(error.localizedDescription)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func play() {
        audioPlayer?.prepareToPlay()
        audioPlayer?.play()
    }
}
