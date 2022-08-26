//
//  HomeView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
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
                    Text("\(post.username) ").bold() + Text("asfasasdfasdfa")
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

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView{
            Text("Homepage")
            ForEach(viewModel.posts){ post in
                PostView(post: post)
            }
        }
    }
}

class HomeViewModel: ObservableObject{
    @Published var posts: [PostModel] = []
    var followings: [String] = []
    
    init(){
        self.listenFollowings()
    }
    
    func getPosts(uids:[String]){
        self.posts.removeAll()
        for uid in uids {
            print(uid)
            FirebaseManager.shared.firestore.collection("users").document(uid).getDocument(as: ProfileModel.self) { result in
                switch result {
                case .success(let profile):
                    for image in profile.images{
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/YY"
                        let date = dateFormatter.string(from: image.timestamp)
                        self.posts.append(PostModel(url: image.url, uid: uid,timestamp: date, username: profile.username, profilePicture: profile.profilePicture))
                    }
                case .failure(let error):
                    print("Error decoding image: \(error)")
                }
            }
            
        }
    }
    
    func listenFollowings(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                return
            }
            
            self.followings = data["followings"] as? [String] ?? []
            self.getPosts(uids: self.followings)
            
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
