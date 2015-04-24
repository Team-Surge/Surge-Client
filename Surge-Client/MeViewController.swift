//
//  MeViewController.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/23/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {
  @IBOutlet weak var showNotificationsButton: UIButton!
  @IBOutlet weak var showMyStuffButton: UIButton!
  weak var notificationsTableView: UIView?
  weak var myStuffTableView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    // Start with notification view on
    if(notificationsTableView != nil) {
      notificationsTableView!.hidden = false
      myStuffTableView!.hidden = true
    }
    
    // Attach button dispatchers
    showNotificationsButton.addTarget(self, action: "toggleViews:", forControlEvents: UIControlEvents.TouchUpInside)
    showMyStuffButton.addTarget(self, action: "toggleViews:", forControlEvents: UIControlEvents.TouchUpInside)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func toggleViews(sender: UIButton!) {
    if(sender == showNotificationsButton) {
      if(notificationsTableView != nil) {
        notificationsTableView!.hidden = false
        myStuffTableView!.hidden = true
      }
    } else if(sender == showMyStuffButton) {
      if(myStuffTableView != nil) {
        myStuffTableView!.hidden = false
        notificationsTableView!.hidden = true
      }
    }
  }
  
  // MARK: - Navigation
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get reference to Notifications and My Stuff views
    if((segue.identifier as String!) == "notificationsTableViewSegue"){
      notificationsTableView = segue.destinationViewController.view!! as UIView
    } else if((segue.identifier as String!) == "myStuffTableViewSegue") {
      myStuffTableView = segue.destinationViewController.view!! as UIView
    }
  }
}
