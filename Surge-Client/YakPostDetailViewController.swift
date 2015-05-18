//
//  YakPostDetailViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 5/18/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//


import SwiftHTTP
import JSONJoy

class YakPostDetailViewController: YakPostViewController {
  internal override func retrievePosts() {
    if let delegate = self.delegate {
      let request = HTTPTask()
      let params: [String:String] = delegate.generatePostRetrieveParameters()
      
      request.POST("http://surge.seektom.com/post", parameters: params,
        success: {(response: HTTPResponse) in
          if response.responseObject != nil {
            let resp = PostDetailResponse(JSONDecoder(response.responseObject!))
            self.posts.removeAll(keepCapacity: true)
            for post in resp.post.comments! {
              self.posts.insert(post, atIndex: 0)
            }
            dispatch_async(dispatch_get_main_queue(),{
              self.tableView.reloadData()
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
}
