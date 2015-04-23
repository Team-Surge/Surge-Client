//
//  NearTableViewCell.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/23/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class NearTableViewCell: UITableViewCell {
  @IBOutlet weak var nearPlaceName: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    nearPlaceName.text = "<Dummy Place>"
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }

}
