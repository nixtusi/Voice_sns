//
//  profile.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/09/19.
//

import Foundation
import Firebase
import FirebaseStorage

class profile: UIViewController, UITextFieldDelegate {
    @IBOutlet var logoutButton: UIButton!
    @IBOutlet var SettingButton: UIButton!
    @IBOutlet var nowName: UILabel!
    //@IBOutlet var iconPhoto: UIImageView!
    //@IBOutlet var collectionView: UICollectionView!
    
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
        
        SettingButton.backgroundColor = UIColor.black// 背景色
        SettingButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        SettingButton.setTitleColor(UIColor.white,for: UIControl.State.normal) // タイトルの色
        SettingButton.layer.borderColor = UIColor.black.cgColor //枠線
        SettingButton.layer.borderWidth = 1.0 //枠線の太さ
        
        // ログイン情報を取得
        auth = Auth.auth()
        
        Firestore.firestore().collection("users").document(auth.currentUser!.uid).getDocument { (snapshot, error) in
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                self.me = AppUser(data: data)
                self.nowName.text = self.me.userName
                self.photoURL = self.me.photoURL
            }
        }
        
        //アイコン
//        func getThumnail(_ photoURL:String) {
//            let photoRef = self.storageRef.child(photoURL)
//            print("tttt")
//            if photoURL != "" {
//                photoRef.getData(maxSize: 30 * 1024 * 1024) {data, error in
//                    if let error = error {
//                        print("SSSS")
//                        print(error.localizedDescription)
//                    }else{
//                        if let imageData = data {
//                            self.thumbnailArray.append(imageData)
//                            print("NNNNNNNNNNNN")
//                        }else{
//                            self.thumbnailArray.append(nil)
//                            print("MMMMMMMM")
//                        }
//                    }
//                }
//            }else{
//                print("ZZZZZZZZ")
//                self.thumbnailArray.append(nil)
//            }
//
//        }
        
        //アイコン
        
//        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//            print("hogeaaaaa")
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostCollectionViewCell
//            let thumbnail = thumbnailArray[indexPath.row]
//            cell.configure(imageData: thumbnail, userName: "", description: "")
//            return cell
//        }
//
//        //Cellの数を指定
//        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//            return thumbnailArray.count
//        }
        
        //collectionView.image = UIImage(data: data)
        
        
    }
    
    //ログアウト
    @IBAction func logout() {
        try? Auth.auth().signOut()
        
        let accountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! AccountViewController
        accountViewController.modalPresentationStyle = .fullScreen
        present(accountViewController, animated: true, completion: nil)
    }
    
    
    
}
