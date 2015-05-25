//
//  MyPostsViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/20/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class MyPostsViewController: UIViewController {

  private var postViewController: YakPostViewController?
  
  @IBAction func sortButtonChanged(sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 1 {
      // Sort by hot
      postViewController?.setCellOrderToHot()
    } else {
      // Sort by new
      postViewController?.setCellOrderToRecent()
    }
  }

  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "embedSegue" {
      postViewController = segue.destinationViewController as? YakPostViewController
      postViewController?.delegate = self
    }
  }
  
}

extension MyPostsViewController: YakPostViewControllerSource {
  func generatePostRetrieveParameters() -> [String:String] {
    return ["action": "postListSelf"]
  }
  
  func notifyWithUpdatedPost(_: AnyObject) {
    // nothing
  }
}
