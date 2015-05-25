//
//  SurgeChatAPIRequests.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/25/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

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
}
