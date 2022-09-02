//
//  ProfilePhotosView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct ProfilePhotosView: View {
    @ObservedObject var viewModel:ProfileViewModel
    var body: some View {
        VStack{
            Picker("profiletab",selection: $viewModel.profileSelection){
                Image(systemName: "square.grid.3x3").tag(0)
                Image(systemName: "paperplane").tag(1)
            }
            .pickerStyle(.segmented)
            TabView(selection: $viewModel.profileSelection){
                PhotosView(imageURLs: viewModel.images,showProfilePhotos: $viewModel.showProfilePhotos, postIndex: $viewModel.postIndex)
                    .tag(0)
                Text("Placeholder")
                    .tag(1)
            }
            .edgesIgnoringSafeArea(.bottom)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct ProfilePhotosView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePhotosView(viewModel: ProfileViewModel(profileType: .user))
    }
}
