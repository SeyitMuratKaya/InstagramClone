//
//  ProfileViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import Foundation

class ProfileViewModel: ObservableObject{
    
    @Published var userName = ""
    
    init(){
        fetchProfile()
    }
    
    private func fetchProfile(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        let doc = FirebaseManager.shared.firestore.collection("users").document(uid)
        
        doc.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["username"] as? String ?? ""
                
            } else {
                print("Document does not exist")
            }
        }
    }
}
