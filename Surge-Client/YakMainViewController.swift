//

//  YakMainViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/21/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class YakMainViewController: UIViewController {
  internal var postViewController: YakPostViewController?
  
  @IBAction func sortButtonChanged(sender: UISegmentedControl) {
    if sender.selectedSegmentIndex == 1 {
      // Sort by hot
      postViewController?.sortCellsByHot()
    } else {
      // Sort by new
      postViewController?.sortCellsByRecent()
    }
  }
  
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "detailViewSegue" {
      let destination = segue.destinationViewController as! YakDetailViewController
      destination.sourcePost = sender as! Post
    } else if segue.identifier == "embedSegue" {
      postViewController = segue.destinationViewController as? YakPostViewController
      postViewController?.delegate = self
    }
  }
  
}

extension YakMainViewController: YakPostViewControllerSource {
  func generatePostRetrieveParameters() -> [String:String] {
    return ["action": "postList"]
  }
  
  func postWasSelected(post: Post) {
    performSegueWithIdentifier("detailViewSegue", sender: post)
  }
}