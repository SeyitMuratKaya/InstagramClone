//
//  AuthViewModel.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 15.08.2022.
//

import Foundation

class AuthViewModel: ObservableObject{
    @Published var email = "murat@gmail.com"
    @Published var password = "123456"
    @Published var username = ""
    @Published var isNewUser = false
    
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
            FirebaseManager.shared.firestore.collection("users").document(uid).setData([
                "username" : self.username
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    viewRouter.currentPage = .contentView
                }
            }
        }
    }
    
    func loginUser(_ viewRouter:ViewRouter){
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, error in
            if let err = error{
                print("failed to login \(err.localizedDescription)")
            }
            print("logged in")
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else{return}
            print(uid)
            viewRouter.currentPage = .contentView
        }
    }
}
