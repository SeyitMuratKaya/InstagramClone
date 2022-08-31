//
//  SearchView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 16.08.2022.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationView{
            VStack{
                VStack{
                    TextField("Search",text: $viewModel.searchText)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(15)
                        .textInputAutocapitalization(.never)
                }
                .padding([.leading,.trailing,.top])
                Divider()
                ScrollView{
                    ForEach(viewModel.users){ user in
                        NavigationLink(destination: ProfileView(profileType: .others, userId: user.userID)) {
                            HStack{
                                AsyncImage(url: URL(string: user.value[1])) { image in
                                    image
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                } placeholder: {
                                    ZStack{
                                        Color.gray
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                VStack(alignment:.leading){
                                    Text(user.value[0])
                                        .foregroundColor(.black)
                                        .font(.headline)
                                    Text("Name")
                                        .foregroundColor(.gray)
                                        .font(.caption)
                                }
                                .padding(.leading)
                                Spacer()
                            }
                            .padding()
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
