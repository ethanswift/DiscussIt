//
//  Message.swift
//  DiscussIt
//
//  Created by ehsan sat on 2/28/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import Foundation
import MessageKit

internal struct Message: MessageType {
    
    var messageId: String
    var sender: SenderType {
        return user
    }
    var sentDate: Date
    var kind: MessageKind
    
    var user: User
    
    private init(kind: MessageKind, user: User, messageId: String, date: Date) {
        self.kind = kind
        self.user = user
        self.messageId = messageId
        self.sentDate = date
    }
    
    init(text: String, user: User, messageId: String, date: Date) {
        self.init(kind: .text(text), user: user, messageId: messageId, date: date)
    }
    
}
