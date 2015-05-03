//
//  YakCreatePostViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/27/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import MapKit

class YakCreatePostViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var textView: UITextView!
  var clearField = true
  
  override func viewDidLoad() {
    textView.delegate = self
    textView.returnKeyType = UIReturnKeyType.Send
    textView.becomeFirstResponder()
    super.viewDidLoad()
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    LocationManager.sharedInstance().removeLocationManagerDelegate(self)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    LocationManager.sharedInstance().addLocationManagerDelegate(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
}

extension YakCreatePostViewController: UITextViewDelegate {
  func textViewDidBeginEditing(textView: UITextView) {
    clearField = true
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    clearField = false
  }
  
  
  func textViewShouldEndEditing(textView: UITextView) -> Bool {
    println("TextViewValue: \(textView.text)")
    navigationController?.popViewControllerAnimated(true)
    return true
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    } else if clearField {
      textView.text = text
      clearField = false
      return false
    } else {
      return true
    }
  }
}

extension YakCreatePostViewController: LocationManagerDelegate {
  func mapViewToUpdateOnNewLocation() -> MKMapView! {
    return mapView
  }
}