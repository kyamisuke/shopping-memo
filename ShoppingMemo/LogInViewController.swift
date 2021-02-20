//
//  LogInViewController.swift
//  ShoppingMemo
//
//  Created by 村上航輔 on 2020/11/29.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LogInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var auth: Auth!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        emailTextField.delegate = self
        passwordTextField.delegate = self
        ref = Database.database().reference()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        auth = Auth.auth()
        if auth.currentUser != nil {
            // もし既にユーザーにログインができていれば、タイムラインの画面に遷移する。
            // このときに、ユーザーの情報を次の画面の変数に値渡ししておく。(直接取得することも可能。)
            performSegue(withIdentifier: "toHome", sender: auth.currentUser!)
        }
    }
    
    @IBAction func logIn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        // sign up
        auth.createUser(withEmail: email, password: password) { (authResult, error) in
            if error == nil, let result = authResult {
                self.performSegue(withIdentifier: "toHome", sender: result.user)
            } else {
                print("error: \(error!)")
            }
            
        }
    }
    
    @IBAction func signIn() {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        auth.signIn(withEmail: email, password: password, completion: { (authResult, error) in
            // 画面遷移
                if error == nil, let result = authResult {
                    self.performSegue(withIdentifier: "toHome", sender: result.user)
                } else {
                    print("error: \(error!)")
                }
        })
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
