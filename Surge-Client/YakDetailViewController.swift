//
//  YakDetailViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/21/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class YakDetailViewController: UIViewController {

  @IBOutlet weak var innerTableView: UITableView!
  @IBOutlet weak var mapView: MKMapView!

  var location: CLLocation!
  
  override func viewDidLoad() {
    // Set map centered to user
    let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.00725, longitudeDelta: 0.00725))
    mapView.setRegion(region, animated: false)
    mapView.showsUserLocation = false
    mapView.delegate = self
  
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    innerTableView.registerNib(UINib(nibName: "YakCell", bundle: nil), forCellReuseIdentifier: "YakCell")
    innerTableView.delegate = self
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
    /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
    
extension YakDetailViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Configure the cell...
    let cell = tableView.dequeueReusableCellWithIdentifier("YakCell", forIndexPath: indexPath) as! YakCell
    cell.karmaLabel.text = "\((indexPath.row + 1) * 5)"
    cell.timeLabel.text = "\((indexPath.row + 1) * 3)m"
    cell.replyLabel.text = "\((indexPath.row + 1) * 1) replies"
    cell.contentLabel.text = "I am cell #\(indexPath.row)"
    return cell
  }
  

}

extension YakDetailViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 1
  }
}

extension YakDetailViewController: MKMapViewDelegate {
  
}