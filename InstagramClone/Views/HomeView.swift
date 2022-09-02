//
//  HomeView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        ScrollView{
            Text("Homepage")
            ForEach(Array(viewModel.posts.enumerated()),id: \.element){ index, post in
                PostView(post: post,index:index)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
