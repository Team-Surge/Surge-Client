//
//  UserStatusResponse.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/26/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import JSONJoy

class UserStatusResponse: JSONJoy {
  var userID: Int!
  var success: Bool!
  required init(_ decoder: JSONDecoder) {
    userID = decoder["userId"].integer
    success = decoder["success"].bool
  }
}
