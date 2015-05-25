//
//  NearTableViewController.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/23/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class NearTableViewController: UITableViewController {
  let featuredLocations = ["University of California, Riverside" : CLLocationCoordinate2DMake(33.973758742572116, -117.32816532254219),
                            "Apple" : CLLocationCoordinate2DMake(37.331419, -122.029637)]
  
  var targetName: String!

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }

  // MARK: - Table view data source

  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return featuredLocations.count
  }

  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("NearTableViewCell", forIndexPath: indexPath) as! NearTableViewCell
    let locations = sorted(featuredLocations.keys)
    let key = locations[indexPath.row]
    cell.nearPlaceName.text = key
    
    return cell
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    targetName = sorted(featuredLocations.keys)[indexPath.row]
    performSegueWithIdentifier("detailViewSegue", sender: self)
  }

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "detailViewSegue" {
      let dest = segue.destinationViewController as! YakPostViewController
      dest.delegate = self
    }
  }
}

extension NearTableViewController: YakPostViewControllerSource {
  // MARK: - YakPostViewControllerSource
  
  func generatePostRetrieveParameters() -> [String:String] {
    let lastLocation = featuredLocations[targetName]
    println(toString(lastLocation!.longitude) + ", " + toString(lastLocation!.latitude))
    return ["action": "postList", "lat": toString(lastLocation!.latitude), "lng": toString(lastLocation!.longitude)]
  }
  
  func notifyWithUpdatedPost(_: AnyObject) {
    // nothing
  }
  
}