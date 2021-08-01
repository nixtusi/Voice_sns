//
//  SignInViewController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/06/06.
//


import UIKit
import Firebase

class SignInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var login: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        emailTextField.placeholder = "メールアドレス"
        passwordTextField.delegate = self
        passwordTextField.placeholder = "パスワード"
        
        login.backgroundColor = UIColor.black // 背景色
        login.layer.cornerRadius = 10.0 // 角丸のサイズ
        login.setTitleColor(UIColor.white,for: UIControl.State.normal) // タイトルの色
        
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Timeline" {
                    let nextViewController = segue.destination as! UITabBarController
                    let navigationController = nextViewController.viewControllers![0] as! UINavigationController
                    let user = sender as! User
                    let timelineViewController = navigationController.topViewController as! TimelineController
                    timelineViewController.me = AppUser(data: ["userID": user.uid])
                }
    }

    @IBAction func tappedSignInButton() {
        let email = emailTextField.text!
        let password = passwordTextField.text!

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error == nil, let result = result, result.user.isEmailVerified {
                self.performSegue(withIdentifier: "Timeline", sender: result.user)
            }else{
                print(error)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
