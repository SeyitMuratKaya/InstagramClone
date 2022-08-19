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
    @State private var isEmailValid = true
    
    var body: some View {
        VStack{
            Text(authViewModel.isNewUser ? "SignUp" : "Login")
                .padding(.top,50)
                .font(.system(size: 50))
            VStack{
                authViewModel.isNewUser ?
                TextField("Username",text: $authViewModel.username)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(.gray,lineWidth: 1)
                    }
                : nil
                VStack{
                    TextField("Email",text: $authViewModel.email)
                        .padding()
                        .textInputAutocapitalization(.never)
                        .overlay{
                            RoundedRectangle(cornerRadius: 5)
                                .strokeBorder(.gray,lineWidth: 1)
                        }
                    if !isEmailValid && authViewModel.isNewUser{
                        HStack{
                            Spacer()
                            Text("incorrect email")
                                .bold()
                                .padding([.trailing])
                                .font(.subheadline)
                                .foregroundColor(.red)
                        }
                    }
                }
                SecureField("Password",text: $authViewModel.password)
                    .padding()
                    .textInputAutocapitalization(.never)
                    .overlay{
                        RoundedRectangle(cornerRadius: 5)
                            .strokeBorder(.gray,lineWidth: 1)
                    }
            }
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
                    if authViewModel.validateInput(){
                        authViewModel.signUpUser(self.viewRouter)
                    }else{
                        isEmailValid = false
                    }
                }else{
                    authViewModel.loginUser(self.viewRouter)
                }
            }label: {
                Text(authViewModel.isNewUser ? "Sign Up" : "Login")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth:.infinity)
                    .background(authViewModel.username.isEmpty && authViewModel.isNewUser ? .gray : .blue)
                    .cornerRadius(10)
            }
            Spacer()
        }
        .padding()
        .onAppear{
            if FirebaseManager.shared.auth.currentUser != nil {
                guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
                print("logged in automaticaly \(uid)")
                viewRouter.currentPage = .contentView
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView()
            .environmentObject(ViewRouter())
    }
}
