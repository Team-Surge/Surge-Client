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
  
  
  @IBOutlet weak var innerTableView: UITableView!
  var location: CLLocation?
  var detailText = ""
  var posts = Array<Post>()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    innerTableView.registerNib(UINib(nibName: "YakCell", bundle: nil), forCellReuseIdentifier: "YakCell")
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
    let request = HTTPTask()
    let params: Dictionary<String,AnyObject> = ["action": "postList"]
    posts.removeAll(keepCapacity: true)
    
    request.POST("http://surge.seektom.com/post", parameters: params, success: {(response: HTTPResponse) in
      if response.responseObject != nil {
        let resp = PostResponse(JSONDecoder(response.responseObject!))
        for post in resp.posts! {
          self.posts.append(post)
        }
        dispatch_async(dispatch_get_main_queue(),{
          self.innerTableView.reloadData()
        })
      }
    }, failure: {(error: NSError, response: HTTPResponse?) in
        println("Failed")
        println("Got an error: \(error)")
    })
    
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
    let post = self.posts[indexPath.row ]
    
    cell.karmaLabel.text = String(post.voteCount!)
    cell.timeLabel.text = "\((indexPath.row + 1) * 3)m"
    cell.replyLabel.text = "\((indexPath.row + 1) * 1) replies"
    cell.contentLabel.text = post.content!
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }

}
