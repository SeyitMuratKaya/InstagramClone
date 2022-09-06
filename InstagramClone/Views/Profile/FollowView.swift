//
//  FollowView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct FollowView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var followPicker:Int
    
    var followers: [FollowModel] = []
    var followings: [FollowModel] = []
        
    var body: some View {
        NavigationView{
            VStack {
                HStack{
                    Button{presentationMode.wrappedValue.dismiss()}label:{Image(systemName: "chevron.left")}
                    Picker("FollowPicker", selection: $followPicker) {
                        Text("Followers").tag(0)
                        Text("Following").tag(1)
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                TabView(selection: $followPicker) {
                    List{
                        ForEach(followers){ follower in
                            NavigationLink(destination: ProfileView(profileType: .others,userId: follower.uid)) {
                                HStack{
                                    AsyncImage(url: URL(string: follower.profilePicture)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else if phase.error != nil {
                                            Color.red
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            ProgressView()
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                    Text(follower.userName)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding([.horizontal])
                            }
                        }
                    }
                    .listStyle(.plain)
                    .tag(0)
                    List{
                        ForEach(followings){ following in
                            NavigationLink(destination: ProfileView(profileType: .others,userId: following.uid)) {
                                HStack{
                                    AsyncImage(url: URL(string: following.profilePicture)) { phase in
                                        if let image = phase.image {
                                            image
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else if phase.error != nil {
                                            Color.red
                                                .frame(width: 40, height: 40)
                                                .clipShape(Circle())
                                        } else {
                                            ProgressView()
                                                .frame(width: 40, height: 40)
                                        }
                                    }
                                    Text(following.userName)
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding([.horizontal])
                            }
                        }
                    }
                    .listStyle(.plain)
                    .tag(1)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
            }
            .navigationBarHidden(true)
        }
        
    }
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView(followPicker: .constant(0))
    }
}
