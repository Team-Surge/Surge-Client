//
//  ChatMessage.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/24/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import JSONJoy

@objc public class ChatMessage: JSQMessage, JSONJoy {
  var senderID: String!
  required public init(_ decoder: JSONDecoder) {
    super.init()
    /*
      Initialize Poll specific vars here...
     */
  }

  required public init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}
