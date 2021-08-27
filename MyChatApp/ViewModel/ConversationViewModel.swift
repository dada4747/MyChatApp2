//
//  ConversatioViewModel.swift
//  MyChatApp
//
//  Created by gadgetzone on 14/08/21.
//

import Foundation
struct ConversationViewModel {
    
    private let conversation: Conversation
    
    var profileURL: URL? {
        return URL(string: conversation.user.profileImageUrl)
    }
    
    var timestamp: String {
        let date =  conversation.message.timestamp.dateValue()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: date)
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
}
