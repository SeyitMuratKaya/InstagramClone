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
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        image = Image(uiImage: inputImage)
    }
    
    func uploadImage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        
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
                self.saveImageToProfile(url: downloadUrl.absoluteString)
            }
        }
    }
    
    func saveImageToProfile(url:String){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "images": FieldValue.arrayUnion([["timestamp": Date(), "url": url,"detailText":self.detailText]])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}
