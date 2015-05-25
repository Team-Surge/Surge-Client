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

@objc public class ChatMessage: NSObject, JSONJoy {
  public var senderID: NSInteger
  var content: NSString
  
  required public init(_ decoder: JSONDecoder) {
    content = decoder["content"].string!
    senderID = decoder["tid"].integer!
  }

}

@objc public class ChatMessageResponse: NSObject, JSONJoy {
  var success: Bool
  var messages = [ChatMessage]()
  var subject: NSString = ""
  var conversationID: NSInteger = -1
  var id: NSInteger = -1
  
  required public init(_ decoder: JSONDecoder) {
    success = decoder["success"].bool
    if success == true {
      let conversation = decoder["conversation"]
      let pivot = conversation["pivot"]
      conversationID = conversation["id"].integer!
      subject = conversation["subject"].string!
      id = pivot["tid"].integer!
      println("FFFFFFF " + toString(id))
      
      let messages = conversation["messages"].array!
      for message in messages {
        self.messages.append(ChatMessage(message))
      }
    }
  }
}