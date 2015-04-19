//
//  TableViewCell.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/16/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class YakCell: UITableViewCell {
  
  @IBOutlet weak var yakText: UILabel!
  @IBOutlet weak var yakTime: UILabel!
  @IBOutlet weak var karmaScore: UILabel!
  @IBOutlet weak var replyCount: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    //yakText.text = "<YakCell Default Text>"
    //yakTime.text = "<1m>"
    //karmaScore.text = "<\(999)>"
    //replyCount.text = "<99 replies>"
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
 