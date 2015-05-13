//
//  PostResponse.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/13/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import JSONJoy

class Post : JSONJoy {
  var content: String!
  var id: Int!
  var created_at: String!
  var handle: String!
  var voteCount: Int!
  var voteState: String!
  var comments: Array<Post>?
  
  init() {
    
  }
  
  required init(_ decoder: JSONDecoder) {
    content = decoder["content"].string
    id = decoder["id"].integer
    created_at = decoder["created_at"].string
    handle = decoder["handle"].string
    voteCount = decoder["voteCount"].integer
    voteState = decoder["userVote"].string
    if let postDecoders = decoder["comments"].array {
      comments = Array<Post>()
      for postDecoder in postDecoders {
        comments!.append(Post(postDecoder))
      }
    }
  }
}

struct PostResponse : JSONJoy {
  var posts: Array<Post>!
  var action: String!
  var success: Bool!
  
  init() {
  }
  
  init(_ decoder: JSONDecoder) {
    action = decoder["action"].string
    success = decoder["success"].bool
    if let postDecoders = decoder["posts"].array {
      posts = Array<Post>()
      for postDecoder in postDecoders {
        posts!.append(Post(postDecoder))
      }
    }
  }
}