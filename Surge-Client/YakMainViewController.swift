//
//  YakMainViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/21/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class YakMainViewController: UIViewController {
  
  @IBOutlet weak var innerTableView: UITableView!
  //var locationManager: CLLocationManager!
  var location: CLLocation?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    innerTableView.registerNib(UINib(nibName: "YakCell", bundle: nil), forCellReuseIdentifier: "YakCell")
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}


extension YakMainViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("detailViewSegue", sender: tableView)
  }

}


extension YakMainViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 12
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("YakCell", forIndexPath: indexPath) as! YakCell
    cell.karmaLabel.text = "\((indexPath.row + 1) * 5)"
    cell.timeLabel.text = "\((indexPath.row + 1) * 3)m"
    cell.replyLabel.text = "\((indexPath.row + 1) * 1) replies"
    cell.contentLabel.text = "I am cell #\(indexPath.row)"
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }

}
