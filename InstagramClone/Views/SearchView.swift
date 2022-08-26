//
//  SearchView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 16.08.2022.
//

import SwiftUI

struct SearchModel:Identifiable{
    var id: String { userID }
    let userID: String
    let value: [String]
}

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

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Search",text: $viewModel.searchText)
                        .textInputAutocapitalization(.never)
                }
                Section{
                    List{
                        ForEach(viewModel.users){ user in
                            NavigationLink(destination: ProfileView(profileType: .others, userId: user.userID)) {
                                HStack{
                                    AsyncImage(url: URL(string: user.value[1])) { image in
                                        image
                                            .resizable()
                                            .frame(width: 50, height: 50)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text(user.value[0])
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(true)
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
