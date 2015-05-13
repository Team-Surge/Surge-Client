//
//  TableViewCell.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/16/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

enum VoteState : String {
  case Upvote = "up"
  case Downvote = "down"
  case Neutral = "neutral"
}

protocol YakCellDelegate : class {
  func cellDidChangeVoteState(cell: YakCell, state: VoteState)
}

class YakCell: UITableViewCell {
  
  var delegate: YakCellDelegate?
  var state = VoteState.Neutral
  var baseKarma = 0
  var id = 0
  
  @IBOutlet weak var replyLabel: UILabel!
  @IBOutlet weak var karmaLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  @IBOutlet weak var upBtn: UIButton!
  @IBOutlet weak var downBtn: UIButton!
  
  @IBAction func buttonPressed(sender: UIButton) {
    switch state {
    case VoteState.Upvote:
      if sender == upBtn {
        state = VoteState.Neutral
      } else if sender == downBtn {
        state = VoteState.Downvote
      }
    case VoteState.Neutral:
      if sender == upBtn {
        state = VoteState.Upvote
      } else if sender == downBtn {
        state = VoteState.Downvote
      }
    case VoteState.Downvote:
      if sender == downBtn {
        state = VoteState.Neutral
      } else if sender == upBtn {
        state = VoteState.Upvote
      }
    }
    evaluateState(true)
  }
  
  func evaluateState(doSendUpdate: Bool) {
    switch state {
    case VoteState.Upvote:
      karmaLabel.text = toString(baseKarma + 1)
      upBtn.selected = true
      downBtn.selected = false
    case VoteState.Neutral:
      karmaLabel.text = toString(baseKarma)
      upBtn.selected = false
      downBtn.selected = false
    case VoteState.Downvote:
      karmaLabel.text = toString(baseKarma - 1)
      upBtn.selected = false
      downBtn.selected = true
    }
    
    if doSendUpdate {
      delegate?.cellDidChangeVoteState(self, state: state)
    }
  }
  
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
  
  
  func initializeCellWithContent(content: String!, voteCount: Int, replyCount: Int, state: VoteState, id: Int) {
    contentLabel.text = content
    karmaLabel.text = toString(baseKarma)
    replyLabel.text = "\(replyCount) replies"
    timeLabel.text = "30s"
    baseKarma = voteCount
    self.id = id
    self.state = state
    
    
    switch state {
    case VoteState.Upvote:
      baseKarma -= 1
    case VoteState.Neutral:
      baseKarma += 0
    case VoteState.Downvote:
      baseKarma += 1
    }
    
    evaluateState(false)
  }
}
 