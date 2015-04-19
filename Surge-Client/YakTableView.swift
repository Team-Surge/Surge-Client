//
//  YakTableView.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/18/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class YakTableView: UIView {

    //override func viewDidLoad() {
    //    super.viewDidLoad()

      // Do any additional setup after loading the view.
    //}

    //override func didReceiveMemoryWarning() {
    //    super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    //}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension YakTableView: UITableViewDelegate {

}

extension YakTableView: UITableViewDataSource {
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 12
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    // Configure the cell...
    let cell = tableView.dequeueReusableCellWithIdentifier("YakCell", forIndexPath: indexPath) as! YakCell
    //cell.karmaScore.text = "\((indexPath.row + 1) * 5)"
    //cell.yakTime.text = "\((indexPath.row + 1) * 3)m"
    //cell.replyCount.text = "\((indexPath.row + 1) * 1) replies"
    return cell
  }
  
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    
    return 1
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 100
  }
}