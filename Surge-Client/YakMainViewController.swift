//

//  YakMainViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/21/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class YakMainViewController: UIViewController {
  
  @IBOutlet weak var innerTableView: UITableView?
  
  private var posts = Array<Post>()
  private let refreshControl = UIRefreshControl()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshControl.addTarget(self, action: Selector("updatePosts"), forControlEvents: UIControlEvents.ValueChanged)
    refreshControl.backgroundColor = UIColor.whiteColor()
    refreshControl.tintColor = UIColor.blackColor()
    
    
    innerTableView?.addSubview(refreshControl)
    innerTableView?.registerNib(UINib(nibName: "YakCell", bundle: nil), forCellReuseIdentifier: "YakCell")
  }
  
  
  override func viewWillAppear(animated: Bool) {
    updatePosts()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == "detailViewSegue" {
      let destination = segue.destinationViewController as! YakDetailViewController
      let selectedCell = sender as! YakCell
      destination.contentText = selectedCell.contentLabel.text
    }
  }
  
  func updatePosts() {
    println("[YakMainViewController] Updating Posts")
    let request = HTTPTask()
    let params: Dictionary<String,AnyObject> = ["action": "postList"]
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
        if response.responseObject != nil {
          let resp = PostResponse(JSONDecoder(response.responseObject!))
          self.posts.removeAll(keepCapacity: true)
          for post in resp.posts! {
            self.posts.append(post)
          }
          dispatch_async(dispatch_get_main_queue(),{
            self.innerTableView?.reloadData()
          })
        }
        self.refreshControl.endRefreshing()
      }, failure: {(error: NSError, response: HTTPResponse?) in
        println("[YakMainViewController] Update Failed with error\n\t\(error)")
        self.refreshControl.endRefreshing()
      }
    )
  }
}


extension YakMainViewController: UITableViewDelegate {
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    performSegueWithIdentifier("detailViewSegue", sender: tableView.cellForRowAtIndexPath(indexPath))
  }

}


extension YakMainViewController: UITableViewDataSource {
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("YakCell", forIndexPath: indexPath) as! YakCell
    let post = self.posts[indexPath.row]
    
    cell.initializeCellWithContent(post.content!, voteCount: post.voteCount!, replyCount: indexPath.row + 1, state: VoteState(rawValue: post.voteState!)!, id: post.id!)
    cell.delegate = self
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }
}

extension YakMainViewController: YakCellDelegate {
  func cellDidChangeVoteState(cell: YakCell, state: VoteState) {
    let request = HTTPTask()
    var params: Dictionary<String,AnyObject> = ["action": "postVote", "postId": cell.id, "direction": state.rawValue]
    
    
    request.POST("http://surge.seektom.com/post", parameters: params, success: {(response: HTTPResponse) in
      if response.responseObject != nil {
        println("[YakMainViewController] Vote Successful")
  
      }
    }, failure: {(error: NSError, response: HTTPResponse?) in
        println("[YakMainViewController] Vote Failed with error:\n\t\(error)")
    })
  }
}