//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import Foundation

enum ProfileType{
    case currentUser, others
}

class ProfileViewModel: ObservableObject{
    
    @Published var userName = ""
    @Published var images: [String] = []
    
    init(){
        fetchProfile()
        updateProfile()
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
}
