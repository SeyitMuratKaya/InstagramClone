//
//  HomeViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 26.08.2022.
//

import Foundation

class HomeViewModel: ObservableObject{
    @Published var posts: [PostModel] = []
    var followings: [String] = []
    
    init(){
        self.listenFollowings()
    }
    
    func getPosts(uids:[String]){
        self.posts.removeAll()
        for uid in uids {
            print(uid)
            FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: ProfileModel.self) { result in
                switch result {
                case .success(let profile):
                    for image in profile.images{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/YY"
                        let date = dateFormatter.string(from: image.timestamp)
                        self.posts.append(PostModel(url: image.url, uid: uid,timestamp: date, username: profile.username, profilePicture: profile.profilePicture, detailText: image.detailText))
                    }
                case .failure(let error):
                    print("Error decoding image: \(error)")
                }
            }
            
        }
    }
    
    func listenFollowings(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            self.followings = data["followings"] as? [String] ?? []
            self.getPosts(uids: self.followings)
            
        }
    }
}
