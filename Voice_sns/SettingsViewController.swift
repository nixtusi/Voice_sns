//
//  SettingsViewController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/06/06.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var userNameTextField: UITextField! //変更するユーザー名
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var logoutButton: UIButton!
    
    var me: AppUser!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.backgroundColor = UIColor.black // 背景色
        saveButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        saveButton.setTitleColor(UIColor.white,for: UIControl.State.normal) // タイトルの色
        
        logoutButton.backgroundColor = UIColor.white // 背景色
        logoutButton.layer.cornerRadius = 10.0 // 角丸のサイズ
        logoutButton.setTitleColor(UIColor.red,for: UIControl.State.normal) // タイトルの色
        logoutButton.layer.borderColor = UIColor.black.cgColor //枠線
        logoutButton.layer.borderWidth = 1.0 //枠線の太さ
        
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
//    //前の画面へ
//    @IBAction func back() {
//        dismiss(animated: true, completion: nil)
//    }
    
    //保存
    @IBAction func save() {
        let newUserName = userNameTextField.text!
            Firestore.firestore().collection("users").document(me.userID).setData([
                "userName": newUserName
            ], merge: true) { error in //データを部分的に更新
                if error == nil {
                    self.dismiss(animated: true, completion: nil)
                }
            }
    }
    
    //ログアウト
    @IBAction func logout() {
        try? Auth.auth().signOut()
        
        let accountViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! AccountViewController
        accountViewController.modalPresentationStyle = .fullScreen
        present(accountViewController, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
}
