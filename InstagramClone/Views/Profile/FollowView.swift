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
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
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
                    ForEach(viewModel.followersArray,id: \.self){ follower in
                        Text(follower)
                    }
                }
                .listStyle(.plain)
                .tag(0)
                List{
                    ForEach(viewModel.followingsArray,id: \.self){ following in
                        Text(following)
                    }
                }
                .listStyle(.plain)
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .onAppear{
            viewModel.chooseUserToFetchFollows()
        }

    }
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView(followPicker: .constant(0), viewModel: ProfileViewModel(profileType: .user))
    }
}
