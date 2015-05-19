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
  
  override func viewDidLoad() {
    textView.delegate = self
    handleField.delegate = self
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
    if count(handleField.text) > 15 {
      SurgeToast.showError("Handle must be less than 15 characters", onCompletion: ({_ in}))
      return false
    } else if count(textView.text) == 0 {
      SurgeToast.showError("Body can't be empty", onCompletion: ({_ in}))
      return false
    }
    return true
  }
  
  func createPostAction() {
    let request = HTTPTask()
    let params: [String:AnyObject] = ["action": "postCreate", "handle": handleField.text, "content": textView.text]
    
    if hasValidPostText() == false {
      return
    }
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
      }, failure: {(error: NSError, response: HTTPResponse?) in
        SurgeToast.showError("Failed to create post", onCompletion: ({_ in}))
      }
    )
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

