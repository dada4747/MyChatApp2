//
//  MessageViewModel.swift
//  MyChatApp
//
//  Created by gadgetzone on 13/08/21.
//

import UIKit

struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? .lightGray : .systemPurple
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    var profileImageURL: URL? {
        guard let user = message.user else { return nil }
        return URL(string: user.profileImageUrl)
    }
    var messageImage: URL? {
        guard let user = message.user else { return nil }
        return URL(string: message.imageUrl)
    }
    init(message: Message) {
        self.message = message
    }
    
}
