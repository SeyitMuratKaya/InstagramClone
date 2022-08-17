//
//  OthersProfileView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 16.08.2022.
//

import SwiftUI

struct OthersProfileView: View {
    @State var profileSelection = 0
    @State private var showFollowSheet = false
    @ObservedObject var viewModel: OthersProfileViewModel
    
    let userId: String
    
    init(userId:String){
        self.userId = userId
        self.viewModel = OthersProfileViewModel(userId: userId)
    }
    
    var body: some View {
        VStack{
            ProfileTopView(showSettingsSheet: .constant(false))
            ProfileDetailView(showFollowSheet: $showFollowSheet, userName: $viewModel.userName, profileType: .others)
            Divider()
            ProfilePhotosView(profileSelection: $profileSelection, images: $viewModel.images)
        }
        .fullScreenCover(isPresented: $showFollowSheet) {
            FollowView(followers: viewModel.followersArray, followings: viewModel.followingsArray)
        }
    }
}

struct OthersProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OthersProfileView(userId: "asd")
    }
}
