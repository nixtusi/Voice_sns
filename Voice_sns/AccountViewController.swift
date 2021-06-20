//
//  AccountViewController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/05/23.
//

import UIKit
import Firebase

class AccountViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        auth = Auth.auth()
        emailTextField.delegate = self
        emailTextField.placeholder = "メールアドレス"
        passwordTextField.delegate = self
        passwordTextField.placeholder = "パスワード(6文字以上)"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if auth.currentUser != nil {
            auth.currentUser?.reload(completion: { error in
                if error == nil {
                    if self.auth.currentUser?.isEmailVerified == true {
                        self.performSegue(withIdentifier: "Timeline", sender: self.auth.currentUser)
                    }else if self.auth.currentUser?.isEmailVerified == false {
                        let alert = UIAlertController(title: "確認用メールを送信しているので確認をお願いします。",message: "まだメール認証が完了していません。", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    // performSegueが呼ばれた時.senderには好きな値が入る.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Timeline" {
            let nextViewController = segue.destination as! TabViewController
            // senderをUserに変換している. user = self.auth.currentUser
            let user = sender as! User
            let timelineViewController = nextViewController.viewControllers?[0] as! TimelineController
            timelineViewController.me = AppUser(data: ["userID": user.uid])
        }
    }
    
    @IBAction func registerAccount() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result {
                result.user.sendEmailVerification(completion: { (error) in
                    if error == nil {
                        let alert = UIAlertController(title: "仮登録を行いました。",message: "入力したメールアドレス宛に確認メールを送信しました。",preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }else{
                print(error)
                print(result)
            }
        }
        
    }

}

extension AccountViewController {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
