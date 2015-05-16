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

  @IBOutlet weak var innerTableView: UITableView?
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var textView: UITextView!
  
  var originalBottomConstraintConstant: CGFloat!
  var sourcePost: Post!
  private var comments = Array<Post>()
  
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
    

    // Setup table cells
    innerTableView?.registerNib(UINib(nibName: "YakCell", bundle: nil), forCellReuseIdentifier: "YakCell")
    innerTableView?.delegate = self

    // Setup text field and keyboard
    textField.delegate = self
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil)
    
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillDisappear(animated)
    LocationManager.sharedInstance().addLocationManagerDelegate(self)
    updatePosts()
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
  
  func updatePosts() {
    let request = HTTPTask()
    let params: Dictionary<String,AnyObject> = ["action": "postDetail", "postId": sourcePost.id!]
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
        if response.responseObject != nil {
          let resp = PostDetailResponse(JSONDecoder(response.responseObject!))
          self.comments.removeAll(keepCapacity: true)
          for comment in resp.post.comments! {
            self.comments.append(comment)
          }
          dispatch_async(dispatch_get_main_queue(),{
            self.innerTableView?.reloadData()
          })
        }
      }, failure: {(error: NSError, response: HTTPResponse?) in
        println("[YakDetailViewController] Update Failed with error\n\t\(error)")
      }
    )
  }

}

// MARK: - UITableViewDelegate
extension YakDetailViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("YakCell", forIndexPath: indexPath) as! YakCell
    let post = self.comments[indexPath.row]
    
    println("\(post.content): \(post.voteState)")
    cell.initializeCellWithContent(post.content!, voteCount: post.voteCount!, replyCount: indexPath.row + 1, state: VoteState(rawValue: post.voteState!)!, id: post.id!, timestamp: post.timestamp)
    cell.replyLabel.hidden = true
    cell.delegate = self
    return cell
  }
  
}

// MARK: - UITableViewDataSource
extension YakDetailViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return comments.count
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
}

// MARK: - UITextFieldDelegate
extension YakDetailViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    let request = HTTPTask()
    let params: Dictionary<String,AnyObject> = ["action": "postCreateComment", "postId": sourcePost.id!, "content": textField.text]
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
          dispatch_async(dispatch_get_main_queue(),{self.updatePosts()})
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

extension YakDetailViewController: LocationManagerDelegate {
  func mapViewToUpdateOnNewLocation() -> MKMapView! {
    return mapView;
  }
}

extension YakDetailViewController: YakCellDelegate {
  func cellDidChangeVoteState(cell: YakCell, state: VoteState) {
    let request = HTTPTask()
    var params: Dictionary<String,AnyObject> = ["action": "postCommentVote", "commentId": cell.id, "direction": state.rawValue]
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
      }, failure: {(error: NSError, response: HTTPResponse?) in
          println("[YakDetailViewController] Vote Failed with error:\n\t\(error)")
      }
    )
  }
}