//
//  TimelineController.swift
//  Voice_sns
//
//  Created by Yuta Nisimatsu on 2021/05/23.
//

import UIKit
import Firebase
import AVFoundation
import FirebaseStorage

class TimelineController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let storageRef = Storage.storage().reference()
    var audioPlayer: AVAudioPlayer?
    var me: AppUser!
    var database: Firestore!
    var postArray: [Post] = []
    @IBOutlet var tableView: UITableView!
    
    fileprivate let refreshCtl = UIRefreshControl()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("呼び出し")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostTableViewCell") as! PostTableViewCell
        //cell.textLabel?.text = postArray[indexPath.row].userName
        
        database.collection("users").document(postArray[indexPath.row].senderID).getDocument { (snapshot, error) in
            
            
            if error == nil, let snapshot = snapshot, let data = snapshot.data() {
                let appUser = AppUser(data: data)
                if tableView.cellForRow(at: indexPath) == nil {
                    print("cell exists")
                    return
                }
                cell.setCell(post: self.postArray[indexPath.row])
                cell.userName.text = appUser.userName
                print("aaa", self.postArray[indexPath.row].photoURL)
                
                let photoRef = self.storageRef.child(self.postArray[indexPath.row].photoURL)
                
                if self.postArray[indexPath.row].photoURL != "" {
                
                    photoRef.getData(maxSize: 30 * 1024 * 1024) {data, error in
                        if let error = error {
                            print("error")
                            print(error.localizedDescription)
                        } else {
                            if let imageData = data {
                                print("画像あああああ")
                                cell.postImage.image = UIImage(data: imageData)
                                
                            }else{
                                print("画像なし")
                                cell.postImage.image = UIImage(systemName: "music.note")
                            }
                        }
                    }
                }
                
            }
        }

        return cell
    }
    
    //cellの高さ指定
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 投稿を全部取得
        database.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.postArray = []
                
                for document in snapshot.documents {
                    // 投稿のデータを取得
                    let data = document.data()
                    // Postを初期化
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
        
        tableView.register(UINib(nibName: "PostTableViewCell", bundle: nil), forCellReuseIdentifier: "PostTableViewCell")
        
        database = Firestore.firestore()
        tableView.delegate = self
        tableView.dataSource = self
        
//        //長押しで画面遷移
//        let press = UILongPressGestureRecognizer(target: self, action: #selector(pressScreen))
//        press.minimumPressDuration = 1.5
//        view.isUserInteractionEnabled = true
//        view.addGestureRecognizer(press)
        
        tableView.refreshControl = refreshCtl
               refreshCtl.addTarget(self, action: #selector(TimelineController.refresh(sender:)), for: .valueChanged)
    }
    
    @objc
    func refresh(sender: UIRefreshControl) {
        // ここが引っ張られるたびに呼び出される
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        // 投稿を全部取得
        database.collection("posts").getDocuments { (snapshot, error) in
            if error == nil, let snapshot = snapshot {
                self.postArray = []
                
                for document in snapshot.documents {
                    // 投稿のデータを取得
                    let data = document.data()
                    // Postを初期化
                    let post = Post(data: data)
                    self.postArray.append(post)
                }
                self.tableView.reloadData()
            }
        }
        refreshCtl.endRefreshing()
    }
//    //投稿画面へ遷移
//    @IBAction func toAddViewController(){
//        performSegue(withIdentifier: "Add", sender: me)
//
//    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(postArray[indexPath.row].content)
        
        let audioRef = storageRef.child(postArray[indexPath.row].content)
            
        audioRef.getData(maxSize: 1 * 1024 * 1024) {data, error in
            if let error = error {
                print("error")
                print(error.localizedDescription)
            } else {
                if let mp3Data = data {
                    do {
                        self.audioPlayer = try AVAudioPlayer(data: mp3Data)
                        self.audioPlayer?.prepareToPlay()
                        self.audioPlayer?.play()
                        print("correct")
                    } catch {
                        print("mp3Data error")
                        print(error.localizedDescription)
                    }
                }
            }
        }
        
    }

}
