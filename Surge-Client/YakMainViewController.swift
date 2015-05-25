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

extension YakMainViewController: YakPostViewControllerSource {
  func generatePostRetrieveParameters() -> [String:String] {
    let lastLocation = LocationManager.sharedInstance().lastLocation
    return ["action": "postList", "lat": toString(lastLocation.coordinate.latitude), "lng": toString(lastLocation.coordinate.longitude)]
  }
  
  func notifyWithUpdatedPost(_: AnyObject) {
    // nothing
  }
}