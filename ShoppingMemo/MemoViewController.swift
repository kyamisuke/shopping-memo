//
//  HomeViewController.swift
//  ShoppingMemo
//
//  Created by 村上航輔 on 2020/12/04.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MemoViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    // 値渡し
    var user: User!
    //    var currentUSer: User!
    
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var userId: String!

    var categoryName: String!
    var memoDataArray = [(memoId:String, shoppingMemo:String, isChecked:Bool)]()
    
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        memoTextField.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        userId = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userId).child(categoryName).queryOrdered(byChild: "isChecked").observe(.childAdded, with: { snapshot in
            let memoId = snapshot.key
            guard let shoppingMemo = snapshot.childSnapshot(forPath: "shoppingMemo").value as? String else { return }
            guard let isChecked = snapshot.childSnapshot(forPath: "isChecked").value as? Bool else { return }
            
            self.memoDataArray.append((memoId: memoId, shoppingMemo: shoppingMemo, isChecked: isChecked))
            self.memoDataArray.sort(by: { (A, B) -> Bool in
                return A.isChecked != true && B.isChecked == true
            })
            self.tableView.reloadData()
        })
        
        ref.child("users").child(userId).child(categoryName).queryOrdered(byChild: "isChecked").observe(.childChanged, with: { snapshot in
            print(snapshot)
            self.memoDataArray.sort(by: { (A, B) -> Bool in
                return A.isChecked != true && B.isChecked == true
            })
            print(self.memoDataArray)
            self.tableView.reloadData()
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let memo = memoTextField.text
        if memo == "" {
            // アラート処理
            let alert = UIAlertController(title: "空欄のままです", message: "テキストを入力してください", preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: { action in
                                    print("press OK")
                                })
            )
            
            present(alert, animated: true, completion: nil)
        } else {
            self.ref.child("users").child(userId).child(categoryName).child("memo\(memoDataArray.count)").updateChildValues(["shoppingMemo":memo!, "isChecked":false])
            memoTextField.text = ""
            let alert = UIAlertController(title: "保存完了", message: "リストに追加しました", preferredStyle: .alert)
            alert.addAction(UIAlertAction(
                                title: "OK",
                                style: .default,
                                handler: { action in
                                    print("press OK")
                                })
            )
            present(alert, animated: true, completion: nil)
        }
        
        return true
    }
    
    @IBAction func signOut(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = memoDataArray[indexPath.row].shoppingMemo
        if memoDataArray[indexPath.row].isChecked {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shoppingMemo = memoDataArray[indexPath.row].shoppingMemo
        let isChecked = memoDataArray[indexPath.row].isChecked
        memoDataArray[indexPath.row].isChecked = !isChecked
//        print(memoIdArray[indexPath.row])
        ref.child("users").child(userId).child(categoryName).child(memoDataArray[indexPath.row].memoId).updateChildValues(["shoppingMemo": shoppingMemo, "isChecked": !isChecked])
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
