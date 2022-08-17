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
    @State private var profileSelection = 0
    @State private var showSettingsSheet = false
    @State private var showFollowSheet = false
    
    @ObservedObject private var viewModel: ProfileViewModel
    @EnvironmentObject var viewRouter: ViewRouter
    
    let profileType:ProfileType
    
    init(profileType:ProfileType){
        self.profileType = profileType
        self.viewModel = ProfileViewModel(profileType: profileType)
    }
    
    var body: some View {
        VStack{
            ProfileTopView(showSettingsSheet: $showSettingsSheet)
            ProfileDetailView(showFollowSheet: $showFollowSheet,userName: $viewModel.userName, profileType: .user)
            Divider()
            ProfilePhotosView(profileSelection: $profileSelection, images: $viewModel.images)
        }
        .sheet(isPresented: $showSettingsSheet) {
            List{
                Button("Sign Out"){
                    do { try FirebaseManager.shared.auth.signOut() }
                    catch { print("already logged out") }
                    viewRouter.currentPage = .authView
                }
            }
        }
        .sheet(isPresented: $showFollowSheet) {
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(profileType: .user)
            .environmentObject(ViewRouter())
    }
}
