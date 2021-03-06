//
//  PostDetailResponse.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/13/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import JSONJoy

class PostDetailResponse : JSONJoy {
  var post: Post!
  var action: String!
  var success: Bool!
  
  required init(_ decoder: JSONDecoder) {
    action = decoder["action"].string
    success = decoder["success"].bool
    post = Post(decoder["post"])
  }
}