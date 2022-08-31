//
//  ProfileCreationView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 22.08.2022.
//

import SwiftUI

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
