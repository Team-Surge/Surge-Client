//
//  TableViewCell.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/16/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class YakCell: UITableViewCell {
  @IBOutlet weak var replyLabel: UILabel!
  @IBOutlet weak var karmaLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    contentLabel.text = "<YakCell Default Text>"
    timeLabel.text = "1m"
    karmaLabel.text = "<\(999)>"
    replyLabel.text = "<99 replies>"
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
 