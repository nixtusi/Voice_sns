//
//  TimelineController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/05/23.
//

import UIKit
import Firebase

class TimelineController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        cell.textLabel?.text = postArray[indexPath.row].content
        
        database.collection("users").document(postArray[indexPath.row].senderID).getDocument { (snapshot, error) in
            
            
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                let appUser = AppUser(data: data)
                cell.detailTextLabel?.text = appUser.userName
            }
        }

        return cell
    }
    
    var me: AppUser!
    var database: Firestore!
    var postArray: [Post] = []
    @IBOutlet var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        database.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.postArray = []
                for document in snapshot.documents {
                    let data = document.data()
                    let post = Post(data: data)
                    self.postArray.append(post)
                }
                self.tableView.reloadData()
            }
        }
        database.collection("users").document(me.userID).setData(["userID": me.userID], merge: true)
        
        database.collection("users").document(me.userID).getDocument { (snapshot, error) in
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                self.me = AppUser(data: data)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        database = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        
        //長押しで画面遷移
        let press = UILongPressGestureRecognizer(target: self, action: #selector(pressScreen))
        press.minimumPressDuration = 1.5
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(press)
    }
    
    //投稿画面へ遷移
    @IBAction func toAddViewController(){
        performSegue(withIdentifier: "Add", sender: me)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add" {
            let destination = segue.destination as! AddViewController
            destination.me = sender as! AppUser
        } else if segue.identifier == "Settings" {
            let destination = segue.destination as! SettingsViewController
            destination.me = me
        }
    }
    
    @objc
    func pressScreen() {
        performSegue(withIdentifier: "Settings", sender: me)
    }
    
    

}
