//
//  NotificationsTableViewCell.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/23/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class NotificationsTableViewCell: UITableViewCell {
  @IBOutlet weak var notificationText: UITextView!
  @IBOutlet weak var timeOfNotificationText: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    // Build sample notification text
    let sampleText = "Someone else replied to the yak \"Just got denied from UCR for missing one transfer credit. Lame!!\"" as NSString
    var attributedString: NSMutableAttributedString = NSMutableAttributedString(string: sampleText as String)
    let eventColor = [NSForegroundColorAttributeName: UIColor.blueColor()]
    
    // Apply blue color to the event part of the string
    attributedString.addAttributes(eventColor, range: sampleText.rangeOfString("Someone else replied to the yak"))
    
    notificationText.attributedText = attributedString
    notificationText.editable = false
    timeOfNotificationText.text = "20h"
    
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
