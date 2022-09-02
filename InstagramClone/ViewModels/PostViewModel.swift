//
//  PostViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 2.09.2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class PostViewModel:ObservableObject{
    @Published var likeStatus = false
    @Published var showCommentsSheet = false
    @Published var likes: [String] = []
    @Published var commentObjects: [CommentModel] = []
    @Published var comments: [Comment] = []
    @Published var owner: String = ""
    
    
    func listenPost(documentId:String){
        FirebaseManager.shared.firestore.collection("images").document(documentId)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                self.likes = data["likes"] as? [String] ?? []
                self.getComments(documentId: documentId)
            }
    }
    
    func getComments(documentId:String){
        FirebaseManager.shared.firestore.collection("images").document(documentId).getDocument(as: ImageModel.self) { result in
            switch result {
            case .success(let image):
                self.commentObjects = image.comments
                self.owner = image.owner
                self.comments.removeAll()
                for user in image.comments{
                    FirebaseManager.shared.firestore.collection("users").document(user.userId).getDocument { document, error in
                        if let document = document, document.exists {
                            let data = document.data()
                            self.comments.append(Comment(profilePicture: data?["profilePicture"] as? String ?? "", username: data?["username"] as? String ?? "",comment: user))
                        } else {
                            print("Document does not exist")
                        }
                    }
                }
                
                
            case .failure(let error):
                print("Error decoding image: \(error)")
            }
        }
        
    }
    
    func isLiked(post:PostModel){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        
        self.likeStatus = post.likes.contains(uid)
    }
    
    func likePost(post:PostModel){
        if self.likeStatus{
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
            FirebaseManager.shared.firestore.collection("images").document(post.documentId).updateData([
                "likes" : FieldValue.arrayUnion([uid])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }else{
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
            FirebaseManager.shared.firestore.collection("images").document(post.documentId).updateData([
                "likes" : FieldValue.arrayRemove([uid])
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            }
        }
    }
    
}
