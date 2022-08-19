//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 11.08.2022.
//

import SwiftUI
enum ProfileType{
    case user,others
}

struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    var userId = ""
    let profileType:ProfileType
    
    init(profileType:ProfileType,userId:String = ""){
        self.userId = userId
        self.profileType = profileType
        self.viewModel = ProfileViewModel(profileType: profileType,userId: userId)
    }
    
    var body: some View {
        VStack{
            ProfileTopView(showSettingsSheet: $viewModel.showSettingsSheet,showImagePickerSheet: $viewModel.showImagePickerSheet)
            ProfileDetailView(viewModel: viewModel)
            Divider()
            ProfilePhotosView(profileSelection: $viewModel.profileSelection, images: $viewModel.images)
        }
        .sheet(isPresented: $viewModel.showSettingsSheet) {
            List{
                Button("Sign Out"){
                    do { try FirebaseManager.shared.auth.signOut() }
                    catch { print("already logged out") }
                    viewRouter.currentPage = .authView
                }
            }
        }
        .sheet(isPresented: $viewModel.showImagePickerSheet, content: {
            ImagePickerView()
        })
        .fullScreenCover(isPresented: $viewModel.showFollowSheet) {
            FollowView(followPicker: $viewModel.followSheetPickerValue, followers: viewModel.followersArray, followings: viewModel.followingsArray)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileType: .user)
            .environmentObject(ViewRouter())
    }
}
