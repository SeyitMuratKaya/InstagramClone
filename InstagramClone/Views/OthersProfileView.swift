//
//  OthersProfileView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 16.08.2022.
//

import SwiftUI
import FirebaseFirestore

class OthersProfileViewModel: ObservableObject{
    @Published var userName = ""
    @Published var images: [String] = []
    
    var userId = ""
    
    init(userId:String){
        self.userId = userId
        fetchProfile()
        updateProfile()
    }
    
    private func fetchProfile(){
        
        let doc = FirebaseManager.shared.firestore.collection("users").document(userId)
        
        doc.getDocument { (document, error) in
            
            if let document = document, document.exists {
                let data = document.data()
                self.userName = data?["username"] as? String ?? ""
                self.images = data?["images"] as? [String] ?? []
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func follow(){
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
        FirebaseManager.shared.firestore.collection("users").document(uid).updateData([
            "following": FieldValue.arrayUnion([userId])
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    private func updateProfile(){
        
    }
}

struct OthersProfileView: View {
    @State var profileSelection = 0
    @ObservedObject var viewModel: OthersProfileViewModel
    
    let userId: String
    
    init(userId:String){
        self.userId = userId
        self.viewModel = OthersProfileViewModel(userId: userId)
    }
    
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
                }
            }
            .padding([.top,.trailing])
            HStack{
                Button{viewModel.follow()}label: {
                    Text("Follow")
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.blue)
                        .cornerRadius(10)
                }
                Button{}label: {
                    Text("Message")
                        .padding(5)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.white)
                        .background(.gray)
                        .cornerRadius(10)
                }
            }
            .padding()
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
                PhotosView(imageURLs: viewModel.images)
                    .tag(0)
                Text("Placeholder")
                    .tag(1)
            }
            .edgesIgnoringSafeArea(.bottom)
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

struct OthersProfileView_Previews: PreviewProvider {
    static var previews: some View {
        OthersProfileView(userId: "asd")
    }
}
