//
//  PullToRefresh.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 5/19/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import Foundation
import UIKit

class SurgePullToRefresh {
  weak var tableViewController: UITableViewController?
  weak var tableView: UITableView?
  weak var refreshControl: UIRefreshControl?
  
  init (target: UITableViewController!, refreshAction: Selector){
    tableViewController = target
    tableView = target.tableView
    
    // Initialize refresh control
    tableViewController!.refreshControl = UIRefreshControl()
    refreshControl = tableViewController!.refreshControl
    
    // Attach action to refresh controller
    refreshControl!.addTarget(tableViewController, action: refreshAction, forControlEvents: UIControlEvents.ValueChanged)
    refreshControl!.addTarget(LocationManager.sharedInstance(), action: Selector("update"), forControlEvents: UIControlEvents.ValueChanged)
    
    // Customize refresh
    refreshControl!.backgroundColor = UIColor.whiteColor()
    refreshControl!.tintColor = UIColor.blackColor()
  }
}