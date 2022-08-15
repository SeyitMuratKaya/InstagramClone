//
//  AuthView.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 11.08.2022.
//

import SwiftUI

struct AuthView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @EnvironmentObject var viewRouter: ViewRouter
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    Group{
                        authViewModel.isNewUser ? TextField("Username",text: $authViewModel.username) : nil
                        TextField("Email",text: $authViewModel.email)
                        SecureField("Password",text: $authViewModel.password)
                    }
                    .padding()
                    .background(.ultraThickMaterial)
                    .cornerRadius(25)
                    .textInputAutocapitalization(.never)
                    HStack{
                        Spacer()
                        Button{
                            authViewModel.isNewUser.toggle()
                        }label: {
                            Text(authViewModel.isNewUser ? "Already have an account?" : "Create new account")
                        }
                    }
                    Button{
                        if authViewModel.isNewUser{
                            authViewModel.signUpUser(self.viewRouter)
                        }else{
                            authViewModel.loginUser(self.viewRouter)
                        }
                    }label: {
                        Text(authViewModel.isNewUser ? "Sign Up" : "Login")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth:.infinity)
                            .background(.blue)
                            .cornerRadius(25)
                    }
                }
                .padding()
            }
            .navigationTitle(authViewModel.isNewUser ? "Sign Up" : "Login")
        }
        .onAppear{
            if FirebaseManager.shared.auth.currentUser != nil {
                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
                print("logged in automaticaly \(uid)")
                viewRouter.currentPage = .contentView
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(ViewRouter())
    }
}
