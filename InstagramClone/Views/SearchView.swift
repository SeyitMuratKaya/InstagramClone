//
//  SearchView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 16.08.2022.
//

import SwiftUI

class SearchViewModel: ObservableObject{
    @Published var filteredUsers: [String:String] = [:]
    @Published var searchText: String = ""
    
    func searchUsers(searchedUser:String){
        FirebaseManager.shared.firestore.collection("users").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var usersDictionary: [String:String] = [:]
                
                for document in querySnapshot!.documents {
//                    usersDictionary.append(document.data()["username"] as! String)
                    usersDictionary[document.documentID] = document.data()["username"] as? String
                }
                self.filteredUsers = usersDictionary.filter({$0.value.contains(searchedUser)})
                print(self.filteredUsers)
            }
        }
    }
}

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Search",text: $viewModel.searchText)
                }
                Section{
                    List{
                        ForEach(viewModel.filteredUsers.sorted(by: >),id: \.key){ userId, userName in
                            NavigationLink(destination: ProfileView(profileType: .others, userId: userId)) {
                                Text(userName)
                            }
                        }
                    }
                }
            }
            .onChange(of: viewModel.searchText) { newValue in
                viewModel.searchUsers(searchedUser: newValue)
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
