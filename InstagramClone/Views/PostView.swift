//
//  PostView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 26.08.2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct PostView: View {
    @StateObject var viewModel = PostViewModel()
    var post: PostModel
    var index: Int
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
                        viewModel.likeStatus.toggle()
                        viewModel.likePost(post: post)
                    }label: {
                        Image(systemName: viewModel.likeStatus ? "heart.fill" : "heart")
                            .padding(.leading,10)
                            .foregroundColor(viewModel.likeStatus ? .red : .black)
                    }
                    Button{
                        viewModel.showCommentsSheet.toggle()
                    }label: {
                        Image(systemName: "bubble.right")
                            .padding(.leading,10)
                            .foregroundColor(.black)
                    }
                    Button{
                    }label: {
                        Image(systemName: "paperplane")
                            .padding(.leading,10)
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Button{
                    }label: {
                        Image(systemName: "bookmark")
                            .padding(.trailing,10)
                            .foregroundColor(.black)
                    }
                }
                .font(.system(size: 20))
            }
            .padding([.top,.bottom],5)
            Group{
                HStack{
                    Text("\(viewModel.likes.count) likes")
                        .bold()
                    Spacer()
                }
                HStack{
                    Text("\(post.username) ").bold() + Text(post.detailText)
                    Spacer()
                }
                HStack{
                    Text("\(post.timestamp)")
                        .font(.caption)
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
            .padding(.leading,10)
        }
        .onAppear{
            viewModel.isLiked(post: post)
            viewModel.listenPost(documentId: post.documentId)
        }
        .fullScreenCover(isPresented: $viewModel.showCommentsSheet) {
            CommentsView(comments: viewModel.comments,documentId: post.documentId,ownerUsername: post.username,postDescription: post.detailText,profilePicture: post.profilePicture)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView(post: PostModel(url: "", uid: "", documentId: "", timestamp: "", username: "", profilePicture: "", detailText: "", likes: []), index: 0)
    }
}
