//
//  SearchViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 26.08.2022.
//

import Foundation

class SearchViewModel: ObservableObject{
    @Published var users = [SearchModel]()
    @Published var searchText: String = ""
    
    func searchUsers(searchedUser:String){
        FirebaseManager.shared.firestore.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.users.removeAll()
                
                for document in querySnapshot!.documents {
                    self.users.append(SearchModel(userID: document.documentID, value: [document.data()["username"] as? String ?? "",document.data()["profilePicture"] as? String ?? ""]))
                }
                
                self.users = self.users.filter({$0.value[0].contains(searchedUser)})
            }
        }
    }
}
