//
//  AuthViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import Foundation

class AuthViewModel: ObservableObject{
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    @Published var isNewUser = false
    @Published var loginStatus = true
    
    var viewRouter: ViewRouter?
    
    
    func validateInput()->Bool{
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailPred.evaluate(with: email)
    }
    
    
    func signUpUser(_ viewRouter:ViewRouter){
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) { result, error in
            if let err = error{
                print("failed to create user \(err.localizedDescription)")
            }
            print("user created")
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
            print(uid)
            let user = ProfileModel(username: self.username, detail: "", profilePicture: "", followers: [], followings: [], images: [])
            do{
                try FirebaseManager.shared.firestore.collection("users").document(uid).setData(from: user)
            }catch let error{
                print(error)
            }
            viewRouter.currentPage = .profileCreationView
        }
    }
    
    func loginUser(_ viewRouter:ViewRouter){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let err = error{
                print("failed to login \(err.localizedDescription)")
                self.loginStatus = false
                return
            }
            print("logged in")
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
            print(uid)
            viewRouter.currentPage = .contentView
        }
    }
}
