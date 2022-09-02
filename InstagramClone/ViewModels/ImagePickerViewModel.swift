//
//  ImagePickerViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 22.08.2022.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ImagePickerViewModel: ObservableObject{
    @Published var image: Image?
    @Published var inputImage: UIImage?
    @Published var showingImagePicker = false
    @Published var detailText = ""
    @Published var imageUploadProgressStatus = false
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        image = Image(uiImage: inputImage)
    }
    
    func uploadImage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        self.imageUploadProgressStatus = true
        let file = UUID()
        
        let storagePath = "\(uid)/images/\(file)"
        
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
                self.saveImage(url: downloadUrl.absoluteString)
            }
        }
    }
    
    func saveImageToProfile(imageId:String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "images": FieldValue.arrayUnion([imageId])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.imageUploadProgressStatus = false
            }
        }
    }
    
    func saveImage(url:String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        let imageID = UUID().uuidString
        FirebaseManager.shared.firestore.collection("images").document(imageID).setData([
            "owner": uid,
            "timestamp": Date(),
            "likes":[],
            "comments":[],
            "detailText": "",
            "url": url
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                self.saveImageToProfile(imageId: imageID)
            }
        }
    }
}
