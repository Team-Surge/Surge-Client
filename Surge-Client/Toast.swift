//
//  Toast.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 5/18/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import Foundation
import CRToast

class SurgeToast {
  static func showError(errorMsg: String, onCompletion: (() -> Void)){
    let errorToastOptions: [NSObject:AnyObject] = [
      kCRToastNotificationTypeKey: CRToastType.NavigationBar.rawValue,
      kCRToastTextAlignmentKey: NSTextAlignment.Center.rawValue,
      kCRToastAnimationInTypeKey: CRToastAnimationType.Linear.rawValue,
      kCRToastAnimationOutTypeKey: CRToastAnimationType.Linear.rawValue,
      kCRToastAnimationInDirectionKey: CRToastAnimationDirection.Top.rawValue,
      kCRToastAnimationOutDirectionKey: CRToastAnimationDirection.Top.rawValue,
      kCRToastTextKey: errorMsg,
      kCRToastBackgroundColorKey: Color.Danger
    ]
   
    CRToastManager.showNotificationWithOptions(errorToastOptions, completionBlock: onCompletion)
  }
  
  static func showSuccess(successMsg: String, onCompletion: (() -> Void)){
    let successToastOptions: [NSObject:AnyObject] = [
      kCRToastNotificationTypeKey: CRToastType.NavigationBar.rawValue,
      kCRToastTextAlignmentKey: NSTextAlignment.Center.rawValue,
      kCRToastAnimationInTypeKey: CRToastAnimationType.Linear.rawValue,
      kCRToastAnimationOutTypeKey: CRToastAnimationType.Linear.rawValue,
      kCRToastAnimationInDirectionKey: CRToastAnimationDirection.Top.rawValue,
      kCRToastAnimationOutDirectionKey: CRToastAnimationDirection.Top.rawValue,
      kCRToastTextKey: successMsg,
      kCRToastBackgroundColorKey: Color.Success
    ]
    
    CRToastManager.showNotificationWithOptions(successToastOptions, completionBlock: onCompletion)
  }
}