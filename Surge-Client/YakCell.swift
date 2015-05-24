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
  var model: Post!
  var delegate: YakCellDelegate?
  var state = VoteState.Neutral
  var baseKarma = 0
  var id = 0
  var timestamp: NSDate!
  
  var showState: Bool = false
  
  @IBOutlet weak var handleLabel: UILabel!
  @IBOutlet weak var replyLabel: UILabel!
  @IBOutlet weak var karmaLabel: UILabel!
  @IBOutlet weak var contentTextView: UITextView!
  @IBOutlet weak var timeLabel: UILabel!

  @IBOutlet var contentTextViewWithHandleTopConstraint: NSLayoutConstraint!
  @IBOutlet var contentTextViewWithoutHandleTopConstraint: NSLayoutConstraint!
  @IBOutlet var contentTextViewWithHandleHeightConstraint: NSLayoutConstraint!
  @IBOutlet var contentTextViewWithoutHandleHeightConstraint: NSLayoutConstraint!
  @IBOutlet var handleLabelExistsHeight: NSLayoutConstraint!
  @IBOutlet var handleLabelDoesntExistHeight: NSLayoutConstraint!
  
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
    
    model.voteState = state.rawValue
    model.voteCount = karmaLabel.text!.toInt()!
    if doSendUpdate {
      delegate?.cellDidChangeVoteState(self, state: state)
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    contentTextView.text = "<YakCell Default Text>"
    timeLabel.text = "1m"
    karmaLabel.text = "<\(999)>"
    replyLabel.text = "<99 replies>"
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  private func getTimeDescriptorFromDate(date: NSDate) -> String {
    let diff = (NSDate().timeIntervalSinceReferenceDate - date.timeIntervalSinceReferenceDate)

    
    if diff < 60 {
      // Seconds
      return toString(Int(diff)) + "s"
    } else if diff < 60*60 {
      // Minutes
      return toString(Int(floor(diff/60))) + "m"
    } else if diff < 60*60*24 {
      // Hours
      return toString(Int(floor(diff/(60*60)))) + "h"
    } else {
      // Days
      return toString(Int(floor(diff/(60*60*24)))) + "d"
    }
    
  }
  
  func initializeCellFromPost(post: Post) {
    self.model = post
    contentTextView.text = model.content
    handleLabel.text = model.handle
    karmaLabel.text = toString(model.voteCount)
    timestamp = model.timestamp
    timeLabel.text = getTimeDescriptorFromDate(model.timestamp)
    baseKarma = model.voteCount
    state = VoteState(rawValue: model.voteState!)!
    id = model.id
    
    if let commentCount = post.commentCount {
      replyLabel.text = "\(commentCount) replies"
    } else {
      replyLabel.hidden = true
    }
    
    
    switch state {
    case VoteState.Upvote:
      baseKarma -= 1
    case VoteState.Neutral:
      baseKarma += 0
    case VoteState.Downvote:
      baseKarma += 1
    }
    
    evaluateState(false)
    setNeedsUpdateConstraints()
  }
  
  override func updateConstraints() {
    if let label = handleLabel.text {
      if label != "" {
        NSLayoutConstraint.activateConstraints([
          contentTextViewWithHandleHeightConstraint,
          contentTextViewWithHandleTopConstraint,
          handleLabelExistsHeight
        ])
        NSLayoutConstraint.deactivateConstraints([
          contentTextViewWithoutHandleHeightConstraint,
          contentTextViewWithoutHandleTopConstraint,
          handleLabelDoesntExistHeight
        ])
      } else {
        NSLayoutConstraint.deactivateConstraints([
          contentTextViewWithHandleHeightConstraint,
          contentTextViewWithHandleTopConstraint,
          handleLabelExistsHeight
        ])
        NSLayoutConstraint.activateConstraints([
          contentTextViewWithoutHandleHeightConstraint,
          contentTextViewWithoutHandleTopConstraint,
          handleLabelDoesntExistHeight
          ])
      }
    }
    super.updateConstraints()
  }
}
 