//
//  LoadingScreen.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 5/25/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class SurgeLoadingScreen {
  private var loadingView: UIView?
  private var mainView: UIView
  private var logoImageView: UIImageView?
  
  init(target: UIView) {
    mainView = target
  }
  
  func displayLoadingScreen() {
    if loadingView == nil {
      // Create loading view
      var screenRect = mainView.bounds
      loadingView = UIView(frame: screenRect)
      
      // Style loading view
      loadingView!.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
      
      // Create logo view
      logoImageView = UIImageView(image: UIImage(named: "Bolt-Logo"))
      
      // Position logo at center of view
      var imageFrame = CGRect(
        x: CGRectGetMidX(screenRect) - logoImageView!.image!.size.width / 2.0,
        y: CGRectGetMidY(screenRect) - logoImageView!.image!.size.height / 2.0,
        width: logoImageView!.image!.size.width,
        height: logoImageView!.image!.size.height)
      logoImageView!.frame = imageFrame
      
      // Animate logo with generic swing -_-
      UIView.animateWithDuration(0.5, delay: 0,
        options: .Repeat | .Autoreverse,
        animations: {
          self.logoImageView!.transform = CGAffineTransformMakeRotation(0.3)
          self.logoImageView!.transform = CGAffineTransformMakeRotation(-0.3)
        },
        completion: nil
      )
      
      // Add logo to loading view
      loadingView?.addSubview(logoImageView!)
  
      // Disable touch on main view
      mainView.userInteractionEnabled = false

      // Install loading view
      mainView.addSubview(loadingView!)
    } else {
      println("Loading view is already displaying!")
    }
  }
  
  func removeLoadingScreen() {
    if loadingView != nil {
      // Enable touch on main view
      mainView.userInteractionEnabled = true
      
      // Remove loading view from main view
      loadingView!.removeFromSuperview()
      
      // Destroy loading view
      loadingView = nil
    } else {
      println("Loading view has not been created yet!")
    }
  }
}
