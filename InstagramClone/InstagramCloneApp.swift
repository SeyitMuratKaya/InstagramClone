//
//  InstagramCloneApp.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 10.08.2022.
//

import SwiftUI
import Firebase
import FirebaseStorage

class FirebaseManager: NSObject{
    let auth:Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init(){
        FirebaseApp.configure()
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        super.init()
    }
}

@main
struct InstagramCloneApp: App {
    
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(viewRouter)
        }
    }
}
