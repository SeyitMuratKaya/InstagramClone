//
//  HomeViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 26.08.2022.
//

import Foundation
import FirebaseFirestore

class HomeViewModel: ObservableObject{
    @Published var posts: [PostModel] = []
    var followings: [String] = []
    var imageIds: [String] = []
    
    init(){
        self.listenFollowings()
    }
    
    
    func findImages(userProfile:ProfileModel){
        self.posts.removeAll()
        for imageId in self.imageIds {
            FirebaseManager.shared.firestore.collection("images").document(imageId).getDocument { (document, error) in
                if let document = document, document.exists {
                    let data = document.data()
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd/MM/YY"
                    var dateString:String = "asdf"
                    if let timestamp = data?["timestamp"] as? Timestamp {
                        let date = timestamp.dateValue()
                        dateString = dateFormatter.string(from: date)
                    }
                    
                    self.posts.append(PostModel(url: data?["url"] as? String ?? "",
                                                uid: data?["owner"] as? String ?? "",
                                                documentId: document.documentID,
                                                timestamp: dateString,
                                                username: userProfile.username,
                                                profilePicture: userProfile.profilePicture,
                                                detailText: data?["detailText"] as? String ?? "",
                                                likes: data?["likes"] as? [String] ?? []))
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    
    func getPosts(uids:[String]){
        for uid in uids {
            print(uid)
            FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: ProfileModel.self) { result in
                switch result {
                case .success(let profile):
                    self.imageIds.removeAll()
                    for image in profile.images{
                        self.imageIds.append(image)
                    }
                    self.findImages(userProfile:profile)
                case .failure(let error):
                    print("Error decoding image: \(error)")
                }
            }
            
        }
    }
    
    func listenFollowings(){
        self.followings.removeAll()
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
