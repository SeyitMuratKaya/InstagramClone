//
//  ProfileDetailView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 17.08.2022.
//

import SwiftUI

struct ProfileDetailView: View {
    @Binding var showFollowSheet:Bool
    @Binding var userName:String
    var profileType:ProfileType
    var body: some View {
        VStack{
            HStack{
                Circle()
                    .padding([.leading])
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fit)
                VStack{
                    HStack{
                        Group{
                            Button{}label:{
                                VStack{
                                    Text("0")
                                        .padding([.bottom],2)
                                        .font(.headline)
                                    Text("Posts")
                                }
                            }
                            Button{showFollowSheet.toggle()}label:{
                                VStack{
                                    Text("0")
                                        .padding([.bottom],2)
                                        .font(.headline)
                                    Text("Followers")
                                }
                            }
                            Button{showFollowSheet.toggle()}label:{
                                VStack{
                                    Text("0")
                                        .padding([.bottom],2)
                                        .font(.headline)
                                    Text("Following")
                                }
                            }
                        }
                        .foregroundColor(.black)
                        .padding([.leading])
                    }
                    Button{
                        
                    }label: {
                        Text("Profile Details")
                            .padding(2)
                            .frame(maxWidth:.infinity)
                            .background(.thickMaterial)
                            .cornerRadius(10)
                    }
                }
            }
            .padding([.top,.trailing])
            switch profileType {
            case .user:
                EmptyView()
            case .others:
                HStack{
                    Button{}label: { // todo follow
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
            }
            VStack(alignment:.leading){
                HStack{
                    Text("\(userName)")
                        .font(.headline)
                    Spacer()
                }
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
            }
            .padding()
            .frame(maxWidth:.infinity)
        }
    }
}

struct ProfileDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileDetailView(showFollowSheet: .constant(false), userName: .constant("Murat"), profileType: .user)
    }
}
