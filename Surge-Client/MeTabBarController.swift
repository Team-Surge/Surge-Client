//
//  MeStuffTabBarController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/20/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class MeTabBarController: UITabBarController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TODO: Maybe subclass UITabBar or UITabBarItem and customize this stuff...
    var tabBarItem0 = tabBar.items![0] as! UITabBarItem
    var tabBarItem1 = tabBar.items![1] as! UITabBarItem
    var unselectedAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 12)!, NSForegroundColorAttributeName : Color.Surge]
    var selectedAttrs = [NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 12)!, NSForegroundColorAttributeName : Color.Blurple]
    
    tabBarItem0.title = "NOTIFICATIONS"
    tabBarItem0.setTitlePositionAdjustment(UIOffsetMake(10, -12))
    tabBarItem0.setTitleTextAttributes(unselectedAttrs, forState: UIControlState.Normal)
    tabBarItem0.setTitleTextAttributes(selectedAttrs, forState: .Selected)
    
    tabBarItem1.title = "MY STUFF"
    tabBarItem1.setTitlePositionAdjustment(UIOffsetMake(10, -12))
    tabBarItem1.setTitleTextAttributes(unselectedAttrs, forState: UIControlState.Normal)
    tabBarItem1.setTitleTextAttributes(selectedAttrs, forState: .Selected)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    var tabBarRect = CGRectMake(0.0, 0.0, view.bounds.size.width, tabBar.bounds.height)
    tabBar.frame = tabBarRect
    tabBar.bounds = tabBarRect
    tabBar.autoresizingMask = .FlexibleWidth | .FlexibleHeight
    
    for subview in self.view.subviews {
      if !subview.isKindOfClass(UITabBar) {
        var sview: UIView = subview as! UIView
        sview.frame = CGRectMake(0.0, tabBar.frame.height, view.bounds.size.width, view.bounds.height - tabBar.frame.height)
      }
    }
  }
  
}
