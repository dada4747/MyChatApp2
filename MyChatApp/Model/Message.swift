//
//  Message.swift
//  MyChatApp
//
//  Created by gadgetzone on 12/08/21.
//

import Firebase

struct Message {
    let text        : String
    let toId        : String
    let fromId      : String
    var timestamp   : Timestamp!
    var user        : User?
    var imageUrl    : String

    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toId : fromId
    }
    
    init(dictionary : [String: Any]) {
        self.text       = dictionary["text"] as? String ?? ""
        self.toId       = dictionary["toId"] as? String ?? ""
        self.fromId     = dictionary["fromId"] as? String ?? ""
        self.timestamp  = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
        self.imageUrl   = (dictionary["imageUrl"] as? String ?? "")

    }
}

struct Conversation {
    let user: User
    let message:Message
}
