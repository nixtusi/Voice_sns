//
//  SettingsViewController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/06/06.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate  {
    
    //　Storageを使うときに初期化するやつ
    let storageRef = Storage.storage().reference()
    
    @IBOutlet var userNameTextField: UITextField! //変更するユーザー名
    @IBOutlet var saveButton: UIButton!
    @IBOutlet weak var verificationImage: UIImageView!
    
    var me: AppUser!
    var auth: Auth!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor.black // 背景色
        saveButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        saveButton.setTitleColor(UIColor.white,for: UIControl.State.normal) // タイトルの色

        userNameTextField.delegate = self
        
        // ログイン情報を取得
        auth = Auth.auth()
        
        Firestore.firestore().collection("users").document(auth.currentUser!.uid).getDocument { (snapshot, error) in
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                self.me = AppUser(data: data)
                self.userNameTextField.text = self.me.userName
            }
        }
        
        userNameTextField.placeholder = "ユーザー名"
    }
    
    //returnキーでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // キーボードを閉じる
        return true
    }

    
    //保存
    @IBAction func save() {
        
        //画像をアップロード
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
            
            let newUserName = self.userNameTextField.text!
            Firestore.firestore().collection("users").document(self.me.userID).setData([
                "userName": newUserName,
                "photoURL": photoName
            ], merge: true) { error in //データを部分的に更新
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        
        //一度サインアウトした方がいい？
//        try? Auth.auth().signOut()
//
//        let accountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! AccountViewController
//        accountViewController.modalPresentationStyle = .fullScreen
//        present(accountViewController, animated: true, completion: nil)
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
