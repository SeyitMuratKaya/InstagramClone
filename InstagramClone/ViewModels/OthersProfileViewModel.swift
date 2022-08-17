//
//  OthersProfileViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import Foundation
import FirebaseFirestore

class OthersProfileViewModel: ObservableObject{
    @Published var userName = ""
    @Published var images: [String] = []
    @Published var followersArray: [String] = []
    @Published var followingsArray: [String] = []
    
    var userId = ""
    
    init(userId:String){
        self.userId = userId
        fetchProfile()
        updateProfile()
        fetchFollows()
    }
    
    private func fetchProfile(){
        
        let doc = FirebaseManager.shared.firestore.collection("users").document(userId)
        
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
    
    private func fetchFollows(){
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
        
    }
    
    private func updateProfile(){
        
    }
}
