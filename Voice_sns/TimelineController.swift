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
import GoogleMobileAds

class TimelineController: UIViewController{
    
    @IBOutlet var collectionView: UICollectionView!
    let storageRef = Storage.storage().reference()
    var isPlaying: Bool = false
    var audioPlayer: AVAudioPlayer?
    var me: AppUser!
    var database: Firestore!
    var postArray: [Post] = []
    var thumbnailArray: [Data?] = []
    var audioArray: [Data?] = []
    
    var bannerView: GADBannerView!

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
                    self.getThumnail(post.photoURL)
                    self.getAudio(post.content)
                }

                self.collectionView.reloadData()
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
        
        //GoogleAD
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        addBannerViewToView(bannerView)
        bannerView.adUnitID = "ca-app-pub-6063835734982611/6362577532"
        //bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        let nib = UINib(nibName: "PostCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "Cell")
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
    
    func getThumnail(_ photoURL:String) {
        let photoRef = self.storageRef.child(photoURL)
        
        if photoURL != "" {
            photoRef.getData(maxSize: 30 * 1024 * 1024) {data, error in
                if let error = error {
                    print("error")
                    print(error.localizedDescription)
                }else{
                    if let imageData = data {
                        self.thumbnailArray.append(imageData)
                        print("画像ああああああ")
                    }else{
                        self.thumbnailArray.append(nil)
                        print("画像なし")
                    }
                }
            }
        }else{
            self.thumbnailArray.append(nil)
        }
    }
    
    
    func getAudio(_ audioURL: String) {
        let audioRef = storageRef.child(audioURL)
        
        audioRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("error")
                print(error.localizedDescription)
                self.audioArray.append(nil)
            }
            
            if let mp3Data = data {
                self.audioArray.append(mp3Data)
            }else{
                self.audioArray.append(nil)
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //現在表示されているCellの番号を取得
        for cell in collectionView.visibleCells {
            let indexPath = collectionView.indexPath(for: cell)
        }
        let pageHeight = scrollView.frame.size.height
        let pageIndex = Int(floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 1)
        
        //音声を再生
        if let audio = audioArray[pageIndex] {
            //音声を再生
            do {
                self.audioPlayer = try AVAudioPlayer(data: audio)
                self.audioPlayer?.prepareToPlay()
                self.audioPlayer?.play()
                print("correct")
            } catch {
                print("mp3Data error")
                print(error.localizedDescription)
            }
        } else {
            print("audio not found")
        }
        
    }
    
    //GoogleAD
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
    }

}

extension TimelineController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("hoge")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PostCollectionViewCell
        let post = postArray[indexPath.row]
        
        //エラー箇所
        let thumbnail = thumbnailArray[indexPath.row]
        
        //let iconImage = photoURL
        cell.configure(imageData: thumbnail, userName: post.userName, description: post.description)
        return cell
    }
    
    //Cellの数を指定
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return postArray.count
    }
    
    //cellが選ばれたとき
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isPlaying {
            isPlaying = false
            audioPlayer?.pause()
        }else{
            isPlaying = true
            audioPlayer?.play()
        }
    }
    
}

extension TimelineController: UICollectionViewDelegateFlowLayout {
    //cellの大きさを指定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height)
    }
}
