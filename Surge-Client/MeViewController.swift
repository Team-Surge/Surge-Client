//
//  MeViewController.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/23/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import MapKit

class MeViewController: UIViewController {
  @IBOutlet weak var showNotificationsButton: UIButton!
  @IBOutlet weak var showMyStuffButton: UIButton!
  @IBOutlet weak var mapView: MKMapView!
  
  weak var notificationsTableView: UIView?
  weak var myStuffTableView: UIView?
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    LocationManager.sharedInstance().addLocationManagerDelegate(self)
    mapView.showsUserLocation = true
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    LocationManager.sharedInstance().removeLocationManagerDelegate(self)
    mapView.showsUserLocation = false
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidAppear(animated: Bool) {
    // Start with notification view on
    if(notificationsTableView != nil && myStuffTableView != nil) {
      notificationsTableView!.hidden = false
      myStuffTableView!.hidden = true
    }
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func toggleViews(sender: UIButton!) {
    if(sender == showNotificationsButton) {
      if(notificationsTableView != nil && myStuffTableView != nil) {
        notificationsTableView!.hidden = false
        myStuffTableView!.hidden = true
      }
    } else if(sender == showMyStuffButton) {
      if(myStuffTableView != nil && notificationsTableView != nil) {
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

extension MeViewController: LocationManagerDelegate {
  
  func mapViewToUpdateOnNewLocation() -> MKMapView! {
    return mapView;
  }
}