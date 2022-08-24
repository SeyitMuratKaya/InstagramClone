//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class ProfileViewModel: ObservableObject{
    @Published var profileSelection = 0
    @Published var showSettingsSheet = false
    @Published var showFollowSheet = false
    @Published var followSheetPickerValue = 0
    @Published var showImagePickerSheet = false
    
    @Published var userName = ""
    @Published var images: [String] = []
    
    @Published var profilePicture:String = ""
    @Published var showPicturePicker = false
    @Published var image: Image?
    @Published var inputImage: UIImage?
    
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
            updateProfile()
        case .others:
            getFollowStatus()
            fetchOthersProfile(userId: userId)
        }
    }
    
    private func updateProfile(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("(updateProfile) Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("(updateProfile) Document data was empty.")
                return
            }
            
            self.images = data["images"] as? [String] ?? []
            
            self.profilePicture = data["profilePicture"] as? String ?? ""
            
            self.userName = data["username"] as? String ?? ""
            
            let followers = data["followers"] as? [String] ?? []
            self.followersCount = String(followers.count)
            
            let followings = data["followings"] as? [String] ?? []
            self.followingsCount = String(followings.count)
            
            self.postCount = String(self.images.count)
            
            print("(updateProfile) user profile updated")
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
    
    //    private func updateOthersProfile(userId:String){
    //
    //        FirebaseManager.shared.firestore.collection("users").document(userId).addSnapshotListener { documentSnapshot, error in
    //            guard let document = documentSnapshot else {
    //                print("Error fetching document: \(error!)")
    //                return
    //            }
    //            guard let data = document.data() else {
    //                print("Document data was empty.")
    //                return
    //            }
    //
    //            self.userName = data["username"] as? String ?? ""
    //            self.images = data["images"] as? [String] ?? []
    //            let followers = data["followers"] as? [String] ?? []
    //            self.followersCount = String(followers.count)
    //            let followings = data["followings"] as? [String] ?? []
    //            self.followingsCount = String(followings.count)
    //            self.postCount = String(self.images.count)
    //
    //            print("others profile updated")
    //        }
    //    }
    
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
                print("(fetchOthersProfile) Document does not exist")
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
        type ? self.followersArray.removeAll() : self.followingsArray.removeAll()
        for uid in uids {
            let doc = FirebaseManager.shared.firestore.collection("users").document(uid)
            doc.getDocument { (document, error) in
                
                if let document = document, document.exists {
                    let data = document.data()
                    let userName = data?["username"] as? String ?? ""
                    type ? self.followersArray.append(userName) : self.followingsArray.append(userName)
                    print(" followings array count \(self.followingsArray)")
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    
}
