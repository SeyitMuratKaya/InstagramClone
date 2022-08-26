//
//  ProfilePostsView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 26.08.2022.
//

import SwiftUI

struct ProfilePostsView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel:ProfileViewModel
    var body: some View {
        VStack{
            HStack{
                Button{presentationMode.wrappedValue.dismiss()}label:{Image(systemName: "chevron.left")}
                Text("Posts")
                    .font(.headline)
                Spacer()
            }
            .padding(.leading)
            ScrollViewReader{ scrollview in
                ScrollView{
                    ForEach(Array(viewModel.posts.enumerated()).reversed(),id:\.element){ index, post in
                        PostView(post: post)
                    }
                }
                .onAppear{
                    scrollview.scrollTo(viewModel.posts[viewModel.postIndex])
                }
            }
        }
    }
}

struct ProfilePostsView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePostsView(viewModel: ProfileViewModel(profileType: .user))
    }
}
