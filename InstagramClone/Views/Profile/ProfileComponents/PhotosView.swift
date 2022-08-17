//
//  PhotosView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct PhotosView: View {
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(),spacing:1), count: 3)
    
    var imageURLs: [String]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 1) {
                ForEach(imageURLs.reversed(), id: \.self) { imageURL in
                    Color.clear.overlay(
                        AsyncImage(url: URL(string: imageURL)) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            default:
                                ZStack{
                                    Color.gray
                                    ProgressView()
                                }
                            }
                        }
                    )
                    .frame(maxWidth: .infinity)
                    .aspectRatio(1, contentMode: .fit)
                    .clipped()
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
