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
    
    var me: AppUser!
    var auth: Auth!

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
