//
//  ProfileCreationView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 22.08.2022.
//

import SwiftUI
import FirebaseFirestore

class ProfileCreationViewModel:ObservableObject{
    @Published var image: Image?
    @Published var inputImage: UIImage?
    
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
            "profilePicture": url
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

struct ProfileCreationView: View {
    @StateObject private var viewModel = ProfileCreationViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var bio:String = ""
    @State private var showImagePicker = false
    
    var body: some View {
        VStack {
            Button{
                showImagePicker.toggle()
            }label: {
                VStack{
                    if let image = viewModel.image {
                        image
                            .resizable()
                    }else{
                        Image(systemName: "person")
                            .resizable()
                    }
                }
            }
            TextEditor(text: $bio)
                .clipShape(RoundedRectangle(cornerRadius: 25))
            Button("save"){
                viewModel.uploadProfilePicture(viewRouter: self.viewRouter)
            }
        }
        .onChange(of: viewModel.inputImage) { _ in viewModel.loadImage() }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        
    }
}

struct ProfileCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCreationView()
    }
}
