//
//  PhotosView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct PhotosView: View {
    let data = (1...100).map { "Item \($0)" }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(),spacing:1), count: 3)
    
    var imageURLs: [String] = []
    @Binding var showProfilePhotos: Bool
    @Binding var postIndex: Int
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 1) {
                ForEach(Array(imageURLs.enumerated()).reversed(),id:\.element) {index, imageURL in
                    GeometryReader{ gr in
                        Button{
                            showProfilePhotos.toggle()
                            postIndex = index
                        }label: {
                            AsyncImage(url: URL(string: imageURL)) { phase in
                                if let image = phase.image{
                                    VStack {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(height: gr.size.width, alignment: .center)
                                    }
                                } else if phase.error != nil {
                                    Color.red
                                }else{
                                    ZStack {
                                        Color.gray
                                        ProgressView()
                                    }
                                }
                            }
                        }
                    }
                    .clipped()
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
    }
}

struct PhotosView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosView(imageURLs: [], showProfilePhotos: .constant(false), postIndex: .constant(0))
    }
}
