//
//  YakCreatePostViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/27/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import MapKit

import SwiftHTTP
import JSONJoy

class YakCreatePostViewController: UIViewController {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var textView: UITextView!
  @IBOutlet weak var handleField: UITextField!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  
  @IBOutlet weak var optionOneField: UITextField!
  @IBOutlet weak var optionTwoField: UITextField!
  @IBOutlet weak var optionThreeField: UITextField!
  @IBOutlet weak var optionFourField: UITextField!
  
  override func viewDidLoad() {
    textView.delegate = self
    handleField.delegate = self
    optionOneField.delegate = self
    optionTwoField.delegate = self
    optionThreeField.delegate = self
    optionFourField.delegate = self
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
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
  
  func keyboardWillShow(notification: NSNotification) {
    var info = notification.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    bottomConstraint.constant = keyboardFrame.size.height - 40
  }
  
  func keyboardWillHide(notification: NSNotification) {
    var info = notification.userInfo!
    var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
    bottomConstraint.constant = 1
  }
  
  func hasValidPostText () -> Bool {
    // Validate handle
    if count(handleField.text) > 15 {
      SurgeToast.showError("Handle must be less than 15 characters", onCompletion: ({_ in}))
      return false
    }
    
    // Validate post text content
    if count(textView.text) == 0 {
      SurgeToast.showError("Body can't be empty", onCompletion: ({_ in}))
      return false
    }
    
    // Validate poll options
    let pollFieldContents = getOptionFields()
    
    for i in 0..<pollFieldContents.count {
      for j in 0...i {
        if pollFieldContents[i] != "" && pollFieldContents[j] == "" {
          SurgeToast.showError("Missing option field", onCompletion: ({_ in}))
          return false
        }
      }
    }
    
    return true
  }
  
  func getOptionFields() -> [String] {
    return [
      optionOneField.text,
      optionTwoField.text,
      optionThreeField.text,
      optionFourField.text
    ]
  }
  
  func createPostAction() {
    let request = HTTPTask()
    let lastLocation = LocationManager.sharedInstance().lastLocation
    var params: [String:AnyObject] = ["action": "postCreate", "handle": handleField.text, "content": textView.text, "lat": toString(lastLocation.coordinate.latitude), "lng": toString(lastLocation.coordinate.longitude)]
    
    if hasValidPostText() == false {
      return
    }
    
    let postFieldContents = getOptionFields()
    if postFieldContents[0] != "" {
      // Poll post
      var numFilledOptions = 0
      for i in postFieldContents {
        if i != "" {
          numFilledOptions += 1
        }
      }
      // Add poll options to params
      params["type"] = "poll"
      params["pollOptionCount"] = numFilledOptions
      for i in 1...4 {
          params["pollOption\(i)"] = postFieldContents[i - 1]
      }
      
      request.POST("http://surge.seektom.com/post", parameters: params,
        success: {(response: HTTPResponse) in
        }, failure: {(error: NSError, response: HTTPResponse?) in
          SurgeToast.showError("Failed to create post", onCompletion: ({_ in}))
        }
      )
    } else {
      // Standard post
      request.POST("http://surge.seektom.com/post", parameters: params,
        success: {(response: HTTPResponse) in
        }, failure: {(error: NSError, response: HTTPResponse?) in
          SurgeToast.showError("Failed to create post", onCompletion: ({_ in}))
        }
      )
    }
    navigationController?.popViewControllerAnimated(true)
  }
}

// MARK: - UITextViewDelegate
extension YakCreatePostViewController: UITextViewDelegate {
  func textViewDidBeginEditing(textView: UITextView) {
    if textView.text == "What's on your mind?" {
      textView.text = ""
    }
  }
  
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      createPostAction()
    }
    return true
  }
}

// MARK: - UITextFieldDelegate
extension YakCreatePostViewController: UITextFieldDelegate {
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    createPostAction()
    return true
  }
}

// MARK: - LocationManagerDelegate
extension YakCreatePostViewController: LocationManagerDelegate {
  func mapViewToUpdateOnNewLocation() -> MKMapView! {
    return mapView
  }
}

