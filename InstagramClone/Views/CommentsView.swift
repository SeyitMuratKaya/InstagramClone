//
//  CommentsView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 2.09.2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct CommentsView: View {
    @Environment(\.presentationMode) var presentationMode
    @State var commentText = ""
    @State var comments: [Comment] = []
    var documentId: String = ""
    var ownerUsername: String = ""
    var postDescription: String = ""
    var profilePicture: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Button{presentationMode.wrappedValue.dismiss()}label:{Image(systemName: "chevron.left")}
                Text("Comments")
                Spacer()
            }
            .padding(.horizontal)
            ScrollView{
                VStack{
                    VStack{
                        HStack{
                            AsyncImage(url: URL(string: profilePicture)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Color.red
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                            }
                            VStack(alignment:.leading){
                                HStack{
                                    Text("\(ownerUsername) ")
                                        .bold()
                                        .font(.system(size: 15))
                                    +
                                    Text(postDescription)
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical,10)
                }
                Divider()
                ForEach(comments){ comment in
                    VStack{
                        HStack{
                            AsyncImage(url: URL(string: comment.profilePicture)) { phase in
                                if let image = phase.image {
                                    image
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else if phase.error != nil {
                                    Color.red
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                } else {
                                    ProgressView()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                }
                            }
                            VStack(alignment:.leading){
                                HStack{
                                    Text("\(comment.username) ")
                                        .bold()
                                        .font(.system(size: 15))
                                    +
                                    Text(comment.comment.comment)
                                        .font(.system(size: 15))
                                    Spacer()
                                }
                                Spacer()
                                Text("19h")
                                    .font(.caption)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical,10)
                }
            }
            HStack{
                TextField("Add Comment...",text: $commentText)
                Button{
                    addComment()
                    commentText = ""
                }label: {
                    Text("Send")
                }
            }
            .padding()
        }
    }
    
    func addComment(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("images").document(documentId).updateData([
            "comments" : FieldValue.arrayUnion([[
                "userId": uid,
                "comment":commentText,
            ]])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView()
    }
}
