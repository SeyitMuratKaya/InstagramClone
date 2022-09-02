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
    let profilePicture: String
}

struct CommentModel:Codable,Identifiable{
    var id: String { UUID().uuidString }
    var userId: String
    var comment: String
}

struct Comment:Identifiable{
    var id: String {UUID().uuidString}
    var profilePicture: String
    var username: String
    var comment: CommentModel
}

struct ImageModel:Codable,Identifiable{
    var id: String { url }
    var owner: String
    var timestamp: Date
    var url: String
    var likes: [String]
    var comments: [CommentModel]
    var detailText:String
}

struct ProfileModel:Codable,Identifiable{
    var id = UUID()
    var username: String
    var detail: String
    var profilePicture: String
    var followers: [String]
    var followings: [String]
    var images: [String]
}

struct PostModel:Identifiable,Hashable{
    var id: String { url }
    var url: String
    var uid: String
    var documentId: String
    var timestamp: String
    var username: String
    var profilePicture: String
    var detailText: String
    var likes: [String]
}

struct SearchModel:Identifiable{
    var id: String { userID }
    let userID: String
    let value: [String]
}
