//
//  APIResponseObjects.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/3/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//


import JSONJoy

struct Post : JSONJoy {
  var content: String?
  var id: Int?
  var created_at: String?
  var handle: String?
  var voteCount: Int?
  
  init() {
    
  }
  
  init(_ decoder: JSONDecoder) {
    content = decoder["content"].string
    id = decoder["id"].integer
    created_at = decoder["created_at"].string
    handle = decoder["handle"].string
    voteCount = decoder["voteCount"].integer
  }
}

struct PostResponse : JSONJoy {
  var posts: Array<Post>?
  var action: String?
  var success: Bool?
  init() {
  }
  
  init(_ decoder: JSONDecoder) {
    action = decoder["action"].string
    success = decoder["success"].bool
    if let postDecoders = decoder["posts"].array {
      println("Success")
      posts = Array<Post>()
      for postDecoder in postDecoders {
        posts!.append(Post(postDecoder))
      }
    }
  }
}