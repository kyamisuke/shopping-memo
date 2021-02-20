//
//  AddViewController.swift
//  ShoppingMemo
//
//  Created by 村上航輔 on 2020/12/18.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    var ref: DatabaseReference!
    var  userId: String!
    var categoriesArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        userId = Auth.auth().currentUser?.uid
        
        // Do any additional setup after loading the view.
        textField.delegate = self
//        ref.child("users").child(userId).observe(.childAdded, with: { snapshot in
//            self.categoriesArray.append(snapshot.key)
//        })
    }
    

    @IBAction func addButton(_ sender: Any) {
        let text = textField.text
//        categoriesArray.append(text!)
        if text != nil {
            let data = ["\(text!)": text]
            ref.child("users").child(userId).updateChildValues(data as [AnyHashable : Any])
        }
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
