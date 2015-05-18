//
//  PostResponse.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/13/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import JSONJoy

struct PostResponse : JSONJoy {
  var posts: [Post]!
  var action: String!
  var success: Bool!
  
  init(_ decoder: JSONDecoder) {
    action = decoder["action"].string
    success = decoder["success"].bool
    if let postDecoders = decoder["posts"].array {
      posts = [Post]()
      for postDecoder in postDecoders {
        posts!.append(Post(postDecoder))
      }
    }
  }
}