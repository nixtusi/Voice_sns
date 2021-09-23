//
//  profile.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/09/19.
//

import Foundation
import Firebase

class profile: UIViewController, UITextFieldDelegate {
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var nowName: UILabel!
    @IBOutlet var iconPhoto: UIImageView!
    
    
    var me: AppUser!
    var auth: Auth!
    var photoURL: String!
    var thumbnailArray: [Data?] = []
    
    let storageRef = Storage.storage().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoutButton.backgroundColor = UIColor.white // 背景色
        logoutButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        logoutButton.setTitleColor(UIColor.red,for: UIControl.State.normal) // タイトルの色
        logoutButton.layer.borderColor = UIColor.black.cgColor //枠線
        logoutButton.layer.borderWidth = 1.0 //枠線の太さ
        
        // ログイン情報を取得
        auth = Auth.auth()
        
        Firestore.firestore().collection("users").document(auth.currentUser!.uid).getDocument { (snapshot, error) in
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                self.me = AppUser(data: data)
                self.nowName.text = self.me.userName
                self.photoURL = self.me.photoURL
            }
            
            //let photoRef = self.storageRef.child(photoURL)
        }
        
        func getThumnail(_ photoURL:String) {
            let photoRef = self.storageRef.child(photoURL)
            
            if photoURL != "" {
                photoRef.getData(maxSize: 30 * 1024 * 1024) {data, error in
                    if let error = error {
                        print("error")
                        print(error.localizedDescription)
                    }else{
                        if let imageData = data {
                            //self.thumbnailArray.append(imageData)
                            //thumbnailArray[1].sd_setImage(with: photoRef)
                            print("画像ああああああ")
                        }else{
                            self.thumbnailArray.append(nil)
                            print("画像なし")
                        }
                    }
                }
            }else{
                self.thumbnailArray.append(nil)
            }
        }
        
        //if let data = imageData {
        //iconPhoto.image = UIImage(systemName: data)
        //} else {
            //iconPhoto.image = UIImage(systemName: "music.note")
        //}
        
        
    }
    
    //ログアウト
    @IBAction func logout() {
        try? Auth.auth().signOut()
        
        let accountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! AccountViewController
        accountViewController.modalPresentationStyle = .fullScreen
        present(accountViewController, animated: true, completion: nil)
    }
    
    
    
}
