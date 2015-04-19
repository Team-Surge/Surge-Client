//
//  TableViewCell.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/16/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class YakCell: UITableViewCell {
  
  @IBOutlet weak var postText: UILabel!
  @IBOutlet weak var postTime: UILabel!
  @IBOutlet weak var karma: UILabel!
  @IBOutlet weak var replyText: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    postText.text = "<YakCell Default Text>"
    postTime.text = "<1m>"
    karma.text = "<\(999)>"
    replyText.text = "<99 replies>"
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
 