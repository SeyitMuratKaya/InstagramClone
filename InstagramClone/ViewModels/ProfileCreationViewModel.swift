//
//  ProfileCreationViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 26.08.2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class ProfileCreationViewModel:ObservableObject{
    @Published var image: Image?
    @Published var inputImage: UIImage?
    @Published var detail:String = ""
    @Published var showImagePicker = false
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        image = Image(uiImage: inputImage)
    }
    
    
    func uploadProfilePicture(viewRouter:ViewRouter){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        
        let storagePath = "\(uid)/profilePicture/"
        
        let ref = FirebaseManager.shared.storage.reference(withPath: storagePath)
        
        guard let imageData = self.inputImage?.jpegData(compressionQuality: 0.5) else {return}
        
        ref.putData(imageData, metadata: nil){ metadata, error in
            if let error = error {
                print("upload error \(error.localizedDescription)")
                return
            }
            ref.downloadURL { url, error in
                guard let downloadUrl = url else{
                    print("url download error")
                    return
                }
                self.saveImageToProfile(url: downloadUrl.absoluteString,viewRouter: viewRouter)
            }
        }
    }
    
    func saveImageToProfile(url:String,viewRouter:ViewRouter){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "profilePicture": url,
            "detail": self.detail
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                viewRouter.currentPage = .contentView
            }
        }
    }
    
}
