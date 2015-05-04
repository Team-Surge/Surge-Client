//
//  LoginResponse.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 5/3/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import Foundation
import JSONJoy

struct LoginResponse: JSONJoy {
  var action: String?
  var success: Bool?
  var reasons: [String:[String]]?
  
  init(_ decoder: JSONDecoder) {
    action = decoder["action"].string
    success = decoder["success"].bool
    decoder.getDictionary(&reasons)
  }
}