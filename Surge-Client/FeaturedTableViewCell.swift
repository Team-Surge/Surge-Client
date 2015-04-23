//
//  FeaturedTableViewCell.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/23/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class FeaturedTableViewCell: UITableViewCell {
  @IBOutlet weak var featuredPlaceName: UILabel!
  @IBOutlet weak var viewedPlaceDot: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    featuredPlaceName.text = "<Dummy Place>"
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}
