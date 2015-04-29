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

class YakDetailViewController: UIViewController,UITextFieldDelegate {

  @IBOutlet weak var innerTableView: UITableView?
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var textField: UITextField!
  
  var originalBottomConstraintConstant: CGFloat!

  
  @IBAction func onSendButtonPress(sender: AnyObject) {
    textFieldShouldReturn(textField)
  }
  
  override func viewDidLoad() {
    // Setup map
    LocationManager.sharedInstance().addLocationManagerDelegate(self)
    mapView.showsUserLocation = false
    mapView.delegate = self
    
    super.viewDidLoad()

    // Setup table cells
    innerTableView?.registerNib(UINib(nibName: "YakCell", bundle: nil), forCellReuseIdentifier: "YakCell")
    innerTableView?.delegate = self

    // Setup text field and keyboard
    textField.delegate = self
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    
  }
  
  override func viewDidAppear(animated: Bool) {
    setMapLocation(LocationManager.sharedInstance().lastLocation)
    
  }
  
  override func viewDidDisappear(animated: Bool) {
    //LocationManager.sharedInstance().removeLocationManagerDelegate(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func keyboardWillHide(notification: NSNotification) {
    var info = notification.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    bottomConstraint.constant = originalBottomConstraintConstant
  }

  func keyboardWillShow(notification: NSNotification) {
    var info = notification.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    originalBottomConstraintConstant = bottomConstraint.constant
    bottomConstraint.constant = keyboardFrame.size.height + bottomConstraint.constant
  }

  func setMapLocation(location: CLLocation!) {
    let center = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.00725, longitudeDelta: 0.00725))
    mapView.setRegion(region, animated: false)
  }
}

// MARK: - UITableViewDelegate
extension YakDetailViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("YakCell", forIndexPath: indexPath) as! YakCell
    cell.karmaLabel.text = "\((indexPath.row + 1) * 5)"
    cell.timeLabel.text = "\((indexPath.row + 1) * 3)m"
    cell.replyLabel.text = "\((indexPath.row + 1) * 1) replies"
    cell.contentLabel.text = "I am cell #\(indexPath.row)"
    return cell
  }
  
}

// MARK: - UITableViewDataSource
extension YakDetailViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 4
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
}

// MARK: - UITextFieldDelegate
extension YakDetailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    println("TextFieldValue: \(textField.text)")
    textField.text = ""
    return true
  }
  
}

// MARK: - MKMapViewDelegate
extension YakDetailViewController: MKMapViewDelegate {
  
}

extension YakDetailViewController: LocationManagerDelegate {
  func locationManagerDidUpdateLocation(location: CLLocation!) {
    setMapLocation(location)
  }
}