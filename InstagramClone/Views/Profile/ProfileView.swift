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
            ProfileTopView(showSettingsSheet: $viewModel.showSettingsSheet,showImagePickerSheet: $viewModel.showImagePickerSheet,profileType: profileType)
            ProfileDetailView(viewModel: viewModel)
            Divider()
            ProfilePhotosView(viewModel: viewModel)
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showSettingsSheet) {
            List{
                Button("Sign Out"){
                    do { try FirebaseManager.shared.auth.signOut() }
                    catch { print("already logged out") }
                    viewRouter.currentPage = .authView
                }
                Button("Edit Bio"){
                    
                }

            }
        }
        .sheet(isPresented: $viewModel.showImagePickerSheet){
            ImagePickerView()
        }
        .sheet(isPresented: $viewModel.showPicturePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        .onChange(of: viewModel.inputImage){ _ in viewModel.updateProfilePicture()}
        .fullScreenCover(isPresented: $viewModel.showFollowSheet) {
            FollowView(followPicker: $viewModel.followSheetPickerValue, viewModel: viewModel)
        }
        .fullScreenCover(isPresented: $viewModel.showProfilePhotos){
            ProfilePostsView(viewModel: viewModel)
        }
        .onAppear{
            if profileType == .others{
                viewModel.fetchOthersProfile(userId: userId)
            }
        }
        .onDisappear{
            switch profileType {
            case .user:
                print("user disappeared")
            case .others:
                print("others disappeared")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileType: .user)
            .environmentObject(ViewRouter())
    }
}
