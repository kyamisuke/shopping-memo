//
//  HomeViewController.swift
//  ShoppingMemo
//
//  Created by 村上航輔 on 2020/12/15.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView:UITableView!
    var userId: String!
    var categoryArray = [String]()
    var ref: DatabaseReference!
    var categoryId: Int!
    var categoryName: String!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        ref = Database.database().reference()
        userId = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userId).observe(.childAdded, with: { snapshot in
            let category = snapshot.key
            self.categoryArray.append(category)
            
            self.tableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeCell")
        cell?.textLabel?.text = categoryArray[indexPath.row]
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        categoryName = cell?.textLabel?.text!
        performSegue(withIdentifier: "toMemo", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMemo" {
            let vc = segue.destination as! MemoViewController
            vc.categoryName = categoryName
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
