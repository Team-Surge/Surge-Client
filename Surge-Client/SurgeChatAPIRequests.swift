//
//  SurgeChatAPIRequests.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/25/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import Foundation
import SwiftHTTP
import JSONJoy

class SurgeChatAPIRequests : NSObject
{
  
  static func createChatFromCommentWithID(commentID: Int, callBack:(Int) -> Void)
  {
      let request = HTTPTask()
      assert(commentID > 0, "CommentID must be greater than 0; Received " + toString(commentID))
      let params: [String:AnyObject] = ["action": "chatCreate", "fromType": "comment", "fromId": commentID]
    
      request.POST("http://surge.seektom.com/chat", parameters: params,
        success: {(response: HTTPResponse) in
          let resp = ChatCreateResponse(JSONDecoder(response.responseObject!))
          callBack(resp.conversationID!)
        }, failure: {(error: NSError, response: HTTPResponse?) in
        }
      )
  }
  
  static func sendMessageWithConversationID(conversationID: Int, message: String)
  {
      let request = HTTPTask()
      let params: [String:AnyObject] = ["action": "chatSend", "conversationId": conversationID, "content": message]
    
      request.POST("http://surge.seektom.com/chat", parameters: params,
        success: {(response: HTTPResponse) in
        }, failure: {(error: NSError, response: HTTPResponse?) in
        }
      )
  }

  static func getUserID(callBack:(NSNumber) -> Void) {
    let params = ["action": "userStatus"]
    let request = HTTPTask()
    request.POST("http://surge.seektom.com/auth", parameters: params,
      success: {(response: HTTPResponse) in
          let resp = UserStatusResponse(JSONDecoder(response.responseObject!))
          callBack(resp.userID)
      }, failure: {(error: NSError, response: HTTPResponse?) in
          println("[SurgeChatAPI] Failed with error:\n\t\(error)")
      }
    )
  }
  
  static func getConversationByCommentID(commentID: Int, callBack:(ChatMessageResponse) -> Void)
  {
      let request = HTTPTask()
      let params: [String:AnyObject] = ["action": "chatDetail", "fromType": "comment", "fromId": commentID]
    
      request.POST("http://surge.seektom.com/chat", parameters: params,
        success: {(response: HTTPResponse) in
          let resp = ChatMessageResponse(JSONDecoder(response.responseObject!))
          callBack(resp)
        }, failure: {(error: NSError, response: HTTPResponse?) in
        }
      )
    
  }
  
  static func getChatServerConnectMessage(userID: Int) -> NSString{
    var params = ["clientType" :"surgeclient", "senderID" : toString(userID), "messageType" : "connect"]
    return JSONStringify(params, prettyPrinted: false)
  }
  // clientType : surgeclient
  // senderID   : userID
  // messageType : connect
  
  
  let jsonObject: [AnyObject] = [
    ["name": "John", "age": 21],
    ["name": "Bob", "age": 35],
  ]
  
  static func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
    var options = prettyPrinted ? NSJSONWritingOptions.PrettyPrinted : nil
    if NSJSONSerialization.isValidJSONObject(value) {
      if let data = NSJSONSerialization.dataWithJSONObject(value, options: options, error: nil) {
        if let string = NSString(data: data, encoding: NSUTF8StringEncoding) {
          return string as String
        }
      }
    }
    return ""
  }
}
