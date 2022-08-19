//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import Foundation
import FirebaseFirestore

class ProfileViewModel: ObservableObject{
    @Published var profileSelection = 0
    @Published var showSettingsSheet = false
    @Published var showFollowSheet = false
    @Published var followSheetPickerValue = 0
    @Published var showImagePickerSheet = false
    
    @Published var userName = ""
    @Published var images: [String] = []
    @Published var followersArray: [String] = []
    @Published var followingsArray: [String] = []
    
    @Published var followStatus:Bool = false
    
    @Published var followersCount:String = ""
    @Published var followingsCount:String = ""
    @Published var postCount:String = ""
    
    var userId = ""
    var profileType = ProfileType.user
    
    init(profileType:ProfileType,userId:String = ""){
        self.userId = userId
        self.profileType = profileType
        
        switch profileType {
        case .user:
            chooseUser()
            fetchProfile()
            updateProfile()
        case .others:
            chooseUser()
            getFollowStatus()
            fetchOthersProfile(userId: userId)
        }
    }
    
    private func updateProfile(){
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
            self.images = data["images"] as? [String] ?? []
            
            let followers = data["followers"] as? [String] ?? []
            self.followersCount = String(followers.count)
            
            let followings = data["followings"] as? [String] ?? []
            self.followingsCount = String(followings.count)
            
            self.postCount = String(self.images.count)
            
            print("profile updated")
        }
    }
    
    private func fetchProfile(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let doc = FirebaseManager.shared.firestore.collection("users").document(uid)
        
        doc.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["username"] as? String ?? ""
                self.images = data?["images"] as? [String] ?? []
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func follow(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "followings": FieldValue.arrayUnion([userId])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        FirebaseManager.shared.firestore.collection("users").document(userId).updateData([
            "followers": FieldValue.arrayUnion([uid])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
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
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        
        FirebaseManager.shared.firestore.collection("users").document(userId).updateData([
            "followers": FieldValue.arrayRemove([uid])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
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
    
    //Other user functions
    private func fetchOthersProfile(userId:String){
        
        let doc = FirebaseManager.shared.firestore.collection("users").document(userId)
        
        doc.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["username"] as? String ?? ""
                self.images = data?["images"] as? [String] ?? []
                let followers = data?["followers"] as? [String] ?? []
                self.followersCount = String(followers.count)
                let followings = data?["followings"] as? [String] ?? []
                self.followingsCount = String(followings.count)
                self.postCount = String(self.images.count)
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    private func findFollows(uids:[String],type:Bool){
        for uid in uids {
            let doc = FirebaseManager.shared.firestore.collection("users").document(uid)
            doc.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    let data = document.data()
                    let userName = data?["username"] as? String ?? ""
                    type ? self.followersArray.append(userName) : self.followingsArray.append(userName)
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    private func chooseUser(){
        if profileType == .user{
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            fetchFollows(userId: uid)
        }else {
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
                
                self.findFollows(uids: followers,type: true)
                self.findFollows(uids: followings,type: false)
                
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
}
