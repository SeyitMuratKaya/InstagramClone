//
//  ImagePickerView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import SwiftUI
import FirebaseFirestore

class ImagePickerViewModel: ObservableObject{
    @Published var image: Image?
    @Published var inputImage: UIImage?
    @Published var showingImagePicker = false
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        
        image = Image(uiImage: inputImage)
    }
    
    func uploadImage(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        
        let file = UUID()
        
        let storagePath = "\(uid)/images/\(file)"
        
        let ref = FirebaseManager.shared.storage.reference(withPath: storagePath)
        
        guard let imageData = self.inputImage?.jpegData(compressionQuality: 1) else {return}
        
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
            "images": FieldValue.arrayUnion([url])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
}

struct ImagePickerView: View {
    @StateObject private var viewModel = ImagePickerViewModel()
    
    var body: some View {
        VStack{
            viewModel.image?
                .resizable()
                .scaledToFit()
            Button("Select Image"){
                viewModel.showingImagePicker.toggle()
            }
            Button("Upload"){
                viewModel.uploadImage()
            }
        }
        .onChange(of: viewModel.inputImage) { _ in viewModel.loadImage() }
        .sheet(isPresented: $viewModel.showingImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        
    }
}

struct ImagePickerView_Previews: PreviewProvider {
    static var previews: some View {
        ImagePickerView()
    }
}
