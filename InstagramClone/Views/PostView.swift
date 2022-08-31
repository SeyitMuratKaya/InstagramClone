//
//  PostView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 26.08.2022.
//

import SwiftUI

struct PostView: View {
    var post: PostModel
    var body: some View {
        VStack{
            HStack{
                AsyncImage(url: URL(string: post.profilePicture)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .clipShape(Circle())
                            .scaledToFit()
                    } else if phase.error != nil {
                        Color.red
                    } else {
                        ZStack{
                            Color.clear
                            ProgressView()
                        }
                        .clipShape(Circle())
                    }
                }
                .frame(width: 35, height: 35)
                Text(post.username)
                Spacer()
                Button{
                    
                }label: {
                    Image(systemName: "chevron.down")
                }
            }
            .padding([.trailing,.leading])
            .padding([.bottom,.top],5)
            AsyncImage(url: URL(string: post.url)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if phase.error != nil {
                    Color.red
                } else {
                    ZStack{
                        Color.clear
                        ProgressView()
                    }
                }
            }
            .aspectRatio(contentMode: .fit)
            HStack{
                Group{
                    Button{
                    }label: {
                        Image(systemName: "heart")
                            .padding(.leading,10)
                    }
                    Button{
                    }label: {
                        Image(systemName: "bubble.right")
                            .padding(.leading,10)
                    }
                    Button{
                    }label: {
                        Image(systemName: "paperplane")
                            .padding(.leading,10)
                    }
                    Spacer()
                    Button{
                    }label: {
                        Image(systemName: "bookmark")
                            .padding(.trailing,10)
                    }
                }
                .font(.system(size: 20))
            }
            .padding([.top,.bottom],5)
            Group{
                HStack{
                    Text("like count")
                    Spacer()
                }
                HStack{
                    Text("\(post.username) ").bold() + Text(post.detailText)
                    Spacer()
                }
                HStack{
                    Text(post.timestamp)
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            .padding(.leading,10)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: PostModel(url: "", uid: "", timestamp: "", username: "", profilePicture: "", detailText: ""))
    }
}
