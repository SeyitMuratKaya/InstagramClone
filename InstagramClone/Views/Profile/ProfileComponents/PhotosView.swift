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
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 1) {
                ForEach(imageURLs.reversed(), id: \.self) { imageURL in
                    GeometryReader{ gr in
                        AsyncImage(url: URL(string: imageURL)) { image in
                            VStack {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: gr.size.width, alignment: .center)
                            }
                        } placeholder: {
                            ZStack {
                                Color.gray
                                ProgressView()
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
        PhotosView(imageURLs: [""])
    }
}
