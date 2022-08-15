//
//  ProfileView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 11.08.2022.
//

import SwiftUI

struct ProfileView: View {
    @State private var profileSelection = 0
    @State private var showSettingsSheet = false
    
    @ObservedObject private var viewModel = ProfileViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        VStack{
            HStack{
                Button{
                    
                }label: {
                    Image(systemName: "plus")
                }
                .padding([.leading])
                Spacer()
                Button{
                    showSettingsSheet.toggle()
                }label: {
                    Image(systemName: "gear")
                }
                .padding([.trailing])
            }
            HStack{
                Circle()
                    .padding([.leading])
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                VStack{
                    HStack{
                        Group{
                            VStack{
                                Text("0")
                                    .padding([.bottom],2)
                                    .font(.headline)
                                Text("Posts")
                            }
                            VStack{
                                Text("0")
                                    .padding([.bottom],2)
                                    .font(.headline)
                                Text("Followers")
                            }
                            VStack{
                                Text("0")
                                    .padding([.bottom],2)
                                    .font(.headline)
                                Text("Following")
                            }
                        }.padding([.leading])
                    }
                    Button("Profile Details"){}
                        .padding(2)
                        .frame(maxWidth:.infinity)
                        .background(.thickMaterial)
                        .cornerRadius(10)
                }
            }
            .padding([.top,.trailing])
            VStack(alignment:.leading){
                HStack{
                    Text("\(viewModel.userName)")
                        .font(.headline)
                    Spacer()
                }
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
            }
            .padding()
            .frame(maxWidth:.infinity)
            Divider()
            Picker("profiletab",selection: $profileSelection){
                Image(systemName: "square.grid.3x3").tag(0)
                Image(systemName: "paperplane").tag(1)
            }
            .pickerStyle(.segmented)
            TabView(selection: $profileSelection){
                PhotosView()
                    .tag(0)
                PhotosView()
                    .tag(1)
            }
            .edgesIgnoringSafeArea(.bottom)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
        .sheet(isPresented: $showSettingsSheet) {
            List{
                Button("Sign Out"){
                    do { try FirebaseManager.shared.auth.signOut() }
                    catch { print("already logged out") }
                    viewRouter.currentPage = .authView
                }
            }
        }
    }
}

struct PhotosView: View {
    let data = (1...99).map { "Item \($0)" }
    
    let columns: [GridItem] = Array(repeating: .init(.flexible(),spacing:1), count: 3)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns,spacing: 1) {
                ForEach(data, id: \.self) { item in
                    Rectangle()
                        .aspectRatio(contentMode: .fit)
                        .overlay{
                            Text(item).foregroundColor(.white)
                        }
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ViewRouter())
    }
}
