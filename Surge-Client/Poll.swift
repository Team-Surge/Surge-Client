//
//  Poll.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 5/24/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import Foundation
import JSONJoy

class Poll : JSONJoy {
  var id: Int!
  var postId: Int!
  var optionCount: Int!
  var option1: String?
  var option2: String?
  var option3: String?
  var option4: String?
  var option1Count: Int?
  var option2Count: Int?
  var option3Count: Int?
  var option4Count: Int?
  
  required init(_ decoder: JSONDecoder) {
    id = decoder["id"].integer
    postId = decoder["post_id"].integer
    optionCount = decoder["optionCount"].integer
    option1 = decoder["option1"].string
    option2 = decoder["option2"].string
    option3 = decoder["option3"].string
    option4 = decoder["option4"].string
    option1Count = decoder["option1Count"].integer
    option2Count = decoder["option2Count"].integer
    option3Count = decoder["option3Count"].integer
    option4Count = decoder["option4Count"].integer
  }
}
