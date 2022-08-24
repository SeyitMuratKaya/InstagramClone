//
//  ImagePickerView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import SwiftUI

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
