//
//  ChatCreateResponse.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/25/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import JSONJoy

@objc class ChatCreateResponse: JSONJoy {
  var conversationID: Int?
  var success: Bool!
  var action: String!
  
  required init(_ decoder: JSONDecoder) {
    action = decoder["action"].string
    success = decoder["success"].bool
    conversationID = decoder["conversationId"].integer!
  }
}