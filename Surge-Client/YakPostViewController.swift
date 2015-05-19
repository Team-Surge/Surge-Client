//
//  YakPostViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/17/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy



protocol YakPostViewControllerSource {
  func generatePostRetrieveParameters() -> [String:String]
  func postWasSelected(post: Post)
}

class YakPostViewController: UITableViewController {
  internal var posts = [Post]()
  internal var delegate: YakPostViewControllerSource?
  internal var orderPostsBy = SortableFeature.Recent
  
  enum SortableFeature {
    case Hot
    case Recent
  }
  
  internal func retrievePosts() {
    if let delegate = self.delegate {
      let request = HTTPTask()
      let params: [String:String] = delegate.generatePostRetrieveParameters()
      
      request.POST("http://surge.seektom.com/post", parameters: params,
        success: {(response: HTTPResponse) in
          if response.responseObject != nil {
            let resp = PostResponse(JSONDecoder(response.responseObject!))
            self.posts.removeAll(keepCapacity: true)
            for post in resp.posts {
              self.posts.insert(post, atIndex: 0)
            }
            dispatch_async(dispatch_get_main_queue(),{
              self.sortCellsAndReload()
              self.refreshControl!.endRefreshing()
            })
          }
        }, failure: {(error: NSError, response: HTTPResponse?) in
          println("[YakMainViewController] Update Failed with error\n\t\(error)")
          dispatch_async(dispatch_get_main_queue(),{
            self.refreshControl!.endRefreshing()
          })
        }
      )
    }
  }
  
  func sortCellsAndReload() {
    switch orderPostsBy {
    case .Hot:
      posts.sort({$0.voteCount > $1.voteCount})
    case .Recent:
      posts.sort({$0.timestamp.timeIntervalSinceReferenceDate > $1.timestamp.timeIntervalSinceReferenceDate})
    default:
      // Shouldn't get here. In case we do, then sort by Recent
      posts.sort({$0.timestamp.timeIntervalSinceReferenceDate > $1.timestamp.timeIntervalSinceReferenceDate})
    }
    tableView.reloadData()
  }
  
  func setCellOrderToHot() {
    orderPostsBy = .Hot
    sortCellsAndReload()
  }
  
  func setCellOrderToRecent() {
    orderPostsBy = .Recent
    sortCellsAndReload()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshControl = UIRefreshControl()
    refreshControl!.addTarget(self, action: Selector("retrievePosts"), forControlEvents: UIControlEvents.ValueChanged)
    refreshControl!.backgroundColor = UIColor.whiteColor()
    refreshControl!.tintColor = UIColor.blackColor()
    
    
    tableView.registerNib(UINib(nibName: "YakCell", bundle: nil), forCellReuseIdentifier: "YakCell")
    retrievePosts()
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("YakCell", forIndexPath: indexPath) as! YakCell
    let post = self.posts[indexPath.row]
    
    cell.initializeCellFromPost(post)
    cell.delegate = self
    return cell
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return posts.count
  }
  
  override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    delegate?.postWasSelected(posts[indexPath.row])
  }
  
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return UITableViewAutomaticDimension
  }

  override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
}

extension YakPostViewController: YakCellDelegate {
  func cellDidChangeVoteState(cell: YakCell, state: VoteState) {
    let request = HTTPTask()
    var params: [String:AnyObject] = ["action": "postVote", "postId": cell.id, "direction": state.rawValue]
    
    
    request.POST("http://surge.seektom.com/post", parameters: params,
      success: {(response: HTTPResponse) in
      }, failure: {(error: NSError, response: HTTPResponse?) in
          println("[YakMainViewController] Vote Failed with error:\n\t\(error)")
      }
    )
  }
}