//
//  ProfilePhotosView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct ProfilePhotosView: View {
    @Binding var profileSelection: Int
    @Binding var images: [String]
    var body: some View {
        VStack{
            Picker("profiletab",selection: $profileSelection){
                Image(systemName: "square.grid.3x3").tag(0)
                Image(systemName: "paperplane").tag(1)
            }
            .pickerStyle(.segmented)
            TabView(selection: $profileSelection){
                PhotosView(imageURLs: images)
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
        ProfilePhotosView(profileSelection: .constant(0), images: .constant([]))
    }
}
