//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileViewModel: ObservableObject{
    @Published var profileSelection = 0
    @Published var showSettingsSheet = false
    @Published var showFollowSheet = false
    @Published var followSheetPickerValue = 0
    @Published var showImagePickerSheet = false
    @Published var showPicturePicker = false
    @Published var showProfilePhotos = false
    
    @Published var followers: [FollowModel] = []
    @Published var followings: [FollowModel] = []
    
    @Published var image: Image?
    @Published var inputImage: UIImage?
    
    @Published var followStatus:Bool = false
    
    @Published var userProfile = ProfileModel(username: "", detail: "", profilePicture: "", followers: [], followings: [], images: [])
    @Published var posts: [PostModel] = []
    @Published var postIndex: Int = 0
    
    var userId = ""
    var profileType = ProfileType.user
    
    init(profileType:ProfileType,userId:String = ""){
        self.userId = userId
        self.profileType = profileType
        
        switch profileType {
        case .user:
            updateProfile()
        case .others:
            getFollowStatus()
        }
    }
    
    private func updateProfile(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("(updateProfile) Error fetching document: \(error!)")
                return
            }
            
            do {
                self.userProfile = try document.data(as: ProfileModel.self)
            }catch{
                print("Error decoding user profile: \(error)")
            }
            print("(updateProfile) user profile updated")
            self.posts.removeAll()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            
            for image in self.userProfile.images{
                self.posts.append(PostModel(url: image.url, uid:uid, timestamp: dateFormatter.string(from: image.timestamp), username: self.userProfile.username, profilePicture: self.userProfile.profilePicture))
            }
            
        }
    }
    
    func follow(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "followings": FieldValue.arrayUnion([userId])
        ]) { err in
            if let err = err {
                print("(follow) Error updating document: \(err)")
            } else {
                print("(follow) Document successfully updated")
            }
        }
        
        FirebaseManager.shared.firestore.collection("users").document(userId).updateData([
            "followers": FieldValue.arrayUnion([uid])
        ]) { err in
            if let err = err {
                print("(follow) Error updating document: \(err)")
            } else {
                print("(follow) Document successfully updated")
            }
        }
        
        self.followStatus = true
    }
    
    func unfollow(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "followings": FieldValue.arrayRemove([userId])
        ]) { err in
            if let err = err {
                print("(unfollow) Error updating document: \(err)")
            } else {
                print("(unfollow) Document successfully updated")
            }
        }
        
        FirebaseManager.shared.firestore.collection("users").document(userId).updateData([
            "followers": FieldValue.arrayRemove([uid])
        ]) { err in
            if let err = err {
                print("(unfollow) Error updating document: \(err)")
            } else {
                print("(unfollow) Document successfully updated")
            }
        }
        
        self.followStatus = false
    }
    
    func getFollowStatus(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        
        let doc = FirebaseManager.shared.firestore.collection("users").document(uid)
        
        doc.getDocument { document, error in
            if let document = document, document.exists{
                let data = document.data()
                
                let followings = data?["followings"] as? [String] ?? []
                
                if followings.contains(self.userId){
                    self.followStatus = true
                }
                
            }
        }
    }
    
    func updateProfilePicture(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        
        let storagePath = "\(uid)/profilePicture"
        
        let ref = FirebaseManager.shared.storage.reference(withPath: storagePath)
        
        guard let imageData = self.inputImage?.jpegData(compressionQuality: 0.5) else {return}
        
        ref.putData(imageData, metadata: nil){ metadata, error in
            if let error = error {
                print("upload error \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let downloadUrl = url else{
                    print("url download error")
                    return
                }
                self.saveImageToProfile(url: downloadUrl.absoluteString)
            }
        }
    }
    
    func saveImageToProfile(url:String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "profilePicture": url
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    //Other user functions
    
    func fetchOthersProfile(userId:String){
        
        let doc = FirebaseManager.shared.firestore.collection("users").document(userId)
        
        doc.getDocument(as: ProfileModel.self) { result in
            
            switch result{
            case .success(let userProfile):
                self.userProfile = userProfile
            case .failure(let error):
                print("Error decoding user profile: \(error)")
            }
            self.posts.removeAll()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/YY"
            for image in self.userProfile.images{
                self.posts.append(PostModel(url: image.url, uid: self.userId, timestamp: dateFormatter.string(from: image.timestamp), username: self.userProfile.username, profilePicture: self.userProfile.profilePicture))
            }
        }
    }
    
    //follow functions -not usable-
    func chooseUserToFetchFollows(){
        if profileType == .user{
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            print("fetching follows of \(uid)")
            fetchFollows(userId: uid)
        }else {
            print("fetching follows of \(userId)")
            fetchFollows(userId: userId)
        }
    }
    
    private func fetchFollows(userId:String){
        let doc = FirebaseManager.shared.firestore.collection("users").document(userId)
        
        doc.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let data = document.data()
                
                let followers = data?["followers"] as? [String] ?? []
                let followings = data?["followings"] as? [String] ?? []
                
                print("fetch follows- followers \(followers.count)")
                print("fetch follows- followings \(followings.count)")
                
                self.findFollows(uids: followers,type: true)
                self.findFollows(uids: followings,type: false)
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func findFollows(uids:[String],type:Bool){
        type ? self.followers.removeAll() : self.followings.removeAll()
        for uid in uids {
            let doc = FirebaseManager.shared.firestore.collection("users").document(uid)
            doc.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    let data = document.data()
                    let userName = data?["username"] as? String ?? ""
                    type ? self.followers.append(FollowModel(uid: uid, userName: userName)) : self.followings.append(FollowModel(uid: uid, userName: userName))
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    
}
