//
//  FollowView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct FollowView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var followPicker = 0
    
    let followers: [String]
    let followings: [String]
    
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
                    ForEach(followers,id: \.self){ follower in
                        Text(follower)
                    }
                }
                .listStyle(.plain)
                .tag(0)
                List{
                    ForEach(followings,id: \.self){ following in
                        Text(following)
                    }
                }
                .tag(1)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }

    }
}

struct FollowView_Previews: PreviewProvider {
    static var previews: some View {
        FollowView(followers: [], followings: [])
    }
}
