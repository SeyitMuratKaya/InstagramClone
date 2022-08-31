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
            VStack{
                Text("Select Image")
                Button{
                    viewModel.showingImagePicker.toggle()
                }label: {
                    if let image = viewModel.image{
                        image
                            .resizable()
                            .scaledToFit()
                            .overlay{
                                if viewModel.imageUploadProgressStatus{
                                    ProgressView("Uploading")
                                        .scaleEffect(3)
                                }
                            }
                    }else{
                        Color.gray
                            .scaledToFit()
                    }
                }
            }
            .padding()
            VStack{
                Text("Detail")
                TextField("",text: $viewModel.detailText)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .overlay{
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(.gray,lineWidth: 1)
                    }
            }
            .padding()
            Button{
                viewModel.uploadImage()
            }label: {
                Text("Upload")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(.blue)
                    .cornerRadius(10)
                    
            }
            .padding()
            Spacer()
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
