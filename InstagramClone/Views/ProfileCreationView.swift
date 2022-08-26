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

struct ProfileCreationView: View {
    @StateObject private var viewModel = ProfileCreationViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack {
            Button{
                viewModel.showImagePicker.toggle()
            }label: {
                VStack{
                    if let image = viewModel.image {
                        image
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }else{
                        Image(systemName: "person")
                            .resizable()
                            .foregroundColor(.gray)
                            .padding()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                    }
                }
                .padding()
            }
            TextEditor(text: $viewModel.detail)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray, lineWidth: 2)
                )
            Button{
                viewModel.uploadProfilePicture(viewRouter: self.viewRouter)
            }label: {
                Text("Save")
                    .foregroundColor(.white)
                    .frame(maxWidth:.infinity)
                    .padding()
                    .background(.blue)
                    .cornerRadius(15)
            }
        }
        .padding()
        .onChange(of: viewModel.inputImage) { _ in viewModel.loadImage() }
        .sheet(isPresented: $viewModel.showImagePicker) {
            ImagePicker(image: $viewModel.inputImage)
        }
        
    }
}

struct ProfileCreationView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileCreationView()
    }
}
