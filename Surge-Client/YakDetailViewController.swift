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
import SwiftHTTP
import JSONJoy

class YakDetailViewController: UIViewController {

  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textView: UITextView!
  
  var sourcePost: Post!
  
  internal var originalBottomConstraintConstant: CGFloat!
  internal var comments = Array<Post>()
  internal var postViewController: YakPostViewController?
  
  @IBAction func onSendButtonPress(sender: AnyObject) {
    textFieldShouldReturn(textField)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    textView.text = sourcePost?.content
    textView.selectable = false
    
    // Setup map
    mapView.showsUserLocation = false
    mapView.delegate = self
    

    // Setup text field and keyboard
    textField.delegate = self
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillDisappear(animated)
    LocationManager.sharedInstance().addLocationManagerDelegate(self)
  }
  
  override func viewDidDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    LocationManager.sharedInstance().removeLocationManagerDelegate(self)
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

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "embedSegue" {
      let postViewController = segue.destinationViewController as! YakPostViewController
      postViewController.delegate = self
    }
  }
}


// MARK: - UITextFieldDelegate
extension YakDetailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    let request = HTTPTask()
    let params: Dictionary<String,AnyObject> = ["action": "postCreateComment", "postId": sourcePost.id!, "content": textField.text]
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
          dispatch_async(dispatch_get_main_queue(),{})
      }, failure: {(error: NSError, response: HTTPResponse?) in
        println("[YakDetailViewController] Update Failed with error\n\t\(error)")
      }
    )
    textField.resignFirstResponder()
    textField.text = ""
    return true
  }
}

// MARK: - MKMapViewDelegate
extension YakDetailViewController: MKMapViewDelegate {
  
}

// MARK: - Location Manager Delegate
extension YakDetailViewController: LocationManagerDelegate {
  func mapViewToUpdateOnNewLocation() -> MKMapView! {
    return mapView;
  }
}

extension YakDetailViewController: YakPostViewControllerSource {
  func generatePostRetrieveParameters() -> Dictionary<String, String> {
    println("Getting: \(sourcePost.id)")
    return ["action": "postDetail", "postId": toString(sourcePost.id)]
  }
  
  func postWasSelected(post: Post) {
  }
}