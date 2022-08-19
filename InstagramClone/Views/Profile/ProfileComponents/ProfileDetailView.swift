//
//  ProfileDetailView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct ProfileDetailView: View {
    @ObservedObject var viewModel:ProfileViewModel
    var body: some View {
        VStack{
            HStack{
                Circle()
                    .padding([.leading])
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                VStack{
                    HStack{
                        Group{
                            Button{}label:{
                                VStack{
                                    Text(viewModel.postCount)
                                        .padding([.bottom],2)
                                        .font(.headline)
                                    Text("Posts")
                                }
                            }
                            Button{
                                viewModel.showFollowSheet.toggle()
                                viewModel.followSheetPickerValue = 0
                            }label:{
                                VStack{
                                    Text(viewModel.followersCount)
                                        .padding([.bottom],2)
                                        .font(.headline)
                                    Text("Followers")
                                }
                            }
                            Button{
                                viewModel.showFollowSheet.toggle()
                                viewModel.followSheetPickerValue = 1
                            }label:{
                                VStack{
                                    Text(viewModel.followingsCount)
                                        .padding([.bottom],2)
                                        .font(.headline)
                                    Text("Following")
                                }
                            }
                        }
                        .foregroundColor(.black)
                        .padding([.leading])
                    }
                    Button{
                        
                    }label: {
                        Text("Profile Details")
                            .padding(2)
                            .frame(maxWidth:.infinity)
                            .background(.thickMaterial)
                            .cornerRadius(10)
                    }
                }
            }
            .padding([.top,.trailing])
            switch viewModel.profileType {
            case .user:
                EmptyView()
            case .others:
                HStack{
                    Button{viewModel.followStatus ? viewModel.unfollow() : viewModel.follow() }label: {
                        Text(viewModel.followStatus ? "Unfollow" : "Follow")
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(viewModel.followStatus ? .gray : .blue)
                            .cornerRadius(10)
                    }
                    Button{}label: {
                        Text("Message")
                            .padding(5)
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.white)
                            .background(.gray)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
            VStack(alignment:.leading){
                HStack{
                    Text("\(viewModel.userName)")
                        .font(.headline)
                    Spacer()
                }
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
            }
            .padding()
            .frame(maxWidth:.infinity)
        }
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(viewModel: ProfileViewModel(profileType: .user))
    }
}
