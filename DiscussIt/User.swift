//
//  User.swift
//  DiscussIt
//
//  Created by ehsan sat on 2/28/20.
//  Copyright © 2020 ehsan sat. All rights reserved.
//

import Foundation
import MessageKit

struct User: SenderType, Equatable {
    var senderId: String
    var displayName: String
}
