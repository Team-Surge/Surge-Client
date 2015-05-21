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
  weak var innerTabBarController: UITabBarController?
  
  @IBOutlet weak var containerView: UIView!
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
}

extension MeViewController: LocationManagerDelegate {
  
  func mapViewToUpdateOnNewLocation() -> MKMapView! {
    return mapView;
  }
}