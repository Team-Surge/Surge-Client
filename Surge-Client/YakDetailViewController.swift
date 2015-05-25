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
  
  @IBOutlet weak var optionViewOne: UIView!
  @IBOutlet weak var optionViewTwo: UIView!
  @IBOutlet weak var optionViewThree: UIView!
  @IBOutlet weak var optionViewFour: UIView!
  
  @IBOutlet weak var optionOneProgress: UIProgressView!
  @IBOutlet weak var optionOneCountLabel: UILabel!
  @IBOutlet weak var optionOneContentLabel: UILabel!
  
  @IBOutlet weak var optionTwoProgress: UIProgressView!
  @IBOutlet weak var optionTwoCountLabel: UILabel!
  @IBOutlet weak var optionTwoContentLabel: UILabel!
  
  @IBOutlet weak var optionThreeProgress: UIProgressView!
  @IBOutlet weak var optionThreeCountLabel: UILabel!
  @IBOutlet weak var optionThreeContentLabel: UILabel!
  
  @IBOutlet weak var optionFourProgress: UIProgressView!
  @IBOutlet weak var optionFourCountLabel: UILabel!
  @IBOutlet weak var optionFourContentLabel: UILabel!
  
  var sourcePost: Post!
  
  internal var originalBottomConstraintConstant: CGFloat!
  internal var comments = [Post]()
  internal var postViewController: YakPostViewController?
  
  @IBAction func onSendButtonPress(sender: AnyObject) {
    textFieldShouldReturn(textField)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    textView.text = sourcePost?.content
    textView.selectable = false
    
    // Hide poll fields
    optionViewOne.hidden = true
    optionViewTwo.hidden = true
    optionViewThree.hidden = true
    optionViewFour.hidden = true
    
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
    let params: [String:AnyObject] = ["action": "postCreateComment", "postId": sourcePost.id!, "content": textField.text]
    
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
  func generatePostRetrieveParameters() -> [String:String] {
    println("Getting: \(sourcePost.id)")
    return ["action": "postDetail", "postId": toString(sourcePost.id)]
  }
  
  func notifyWithUpdatedPost(postDetail: AnyObject) {
    let postDetail = postDetail as! PostDetailResponse
    
    // Update poll fields if incoming post is a poll
    if let poll = postDetail.post?.poll {
      var pollCount: Float = 0.0
      
      // Set all option fields
      if let optionOneContent = poll.option1 {
        optionOneCountLabel.text = String(poll.option1Count!)
        optionOneContentLabel.text = optionOneContent
        optionViewOne.hidden = false
        pollCount += Float(poll.option1Count!)
      }
      
      if let optionTwoContent = poll.option2 {
        optionTwoCountLabel.text = String(poll.option2Count!)
        optionTwoContentLabel.text = optionTwoContent
        optionViewTwo.hidden = false
        pollCount += Float(poll.option2Count!)
      }
      
      if let optionThreeContent = poll.option3 {
        optionThreeCountLabel.text = String(poll.option3Count!)
        optionThreeContentLabel.text = optionThreeContent
        optionViewThree.hidden = false
        pollCount += Float(poll.option3Count!)
      }
      
      if let optionFourContent = poll.option4 {
        optionFourCountLabel.text = String(poll.option4Count!)
        optionFourContentLabel.text = optionFourContent
        optionViewFour.hidden = false
        pollCount += Float(poll.option4Count!)
      }
      
      // If not post votes have been made, we should set it to 1 to make sure
      // we never divide by 0
      if pollCount == 0 {
        pollCount = 1
      }
      
      // Update progress bars
      if let optionOneCount = poll.option1Count {
        optionOneProgress.setProgress(Float(optionOneCount) / pollCount, animated: true)
      }
      
      if let optionTwoCount = poll.option2Count {
        optionTwoProgress.setProgress(Float(optionTwoCount) / pollCount, animated: true)
      }
      
      if let optionThreeCount = poll.option3Count {
        optionThreeProgress.setProgress(Float(optionThreeCount) / pollCount, animated: true)
      }
      
      if let optionFourCount = poll.option4Count {
        optionFourProgress.setProgress(Float(optionFourCount) / pollCount, animated: true)
      }
    }
  }
}