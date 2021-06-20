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
    
    var me: AppUser!
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameTextField.delegate = self
        //userNameTextField.text = me.userName //現在のユーザー名を表示
        // ログイン情報を取得
        auth = Auth.auth()
        me = AppUser(data: ["userID": auth.currentUser!.uid])
        userNameTextField.text = me.userName
        
    }
    
    //returnキーでキーボードを閉じる
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // キーボードを閉じる
        return true
    }
    
    //前の画面へ
    @IBAction func back() {
        dismiss(animated: true, completion: nil)
    }
    
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
    
}
