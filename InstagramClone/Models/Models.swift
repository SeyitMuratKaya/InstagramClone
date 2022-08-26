//
//  Models.swift
//  InstagramClone
//
//  Created by Seyit Murat Kaya on 25.08.2022.
//

import Foundation

struct FollowModel:Identifiable,Codable{
    var id: String { uid }
    let uid: String
    let userName: String
}

struct ImageModel:Codable,Identifiable,Hashable{
    var id: String { url }
    var timestamp: Date
    var url: String
}

struct ProfileModel:Codable,Identifiable{
    var id = UUID()
    var username: String
    var detail: String
    var profilePicture: String
    var followers: [String]
    var followings: [String]
    var images: [ImageModel]
}

struct PostModel:Identifiable,Hashable{
    var id: String { url }
    var url: String
    var uid: String
    var timestamp: String
    var username: String
    var profilePicture: String
}
