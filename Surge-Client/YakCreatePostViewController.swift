//
//  YakCreatePostViewController.swift
//  Surge-Client
//
//  Created by Dustin Guerrero on 4/27/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import MapKit

class YakCreatePostViewController: UIViewController {
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var textView: UITextView!
  var clearField = true
  //@IBOutlet weak var navBar: UINavigationBar!
  
  override func viewDidLoad() {
    textView.delegate = self
    textView.returnKeyType = UIReturnKeyType.Send
    textView.becomeFirstResponder()
    super.viewDidLoad()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  }
}

extension YakCreatePostViewController: UITextViewDelegate {
  func textViewDidBeginEditing(textView: UITextView) {
    clearField = true
  }
  
  func textViewDidEndEditing(textView: UITextView) {
    clearField = false
  }
  
  
  func textViewShouldEndEditing(textView: UITextView) -> Bool {
    //textView.resignFirstResponder()
    println("TextViewValue: \(textView.text)")
    navigationController?.popViewControllerAnimated(true)
    return true
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if text == "\n" {
      textView.resignFirstResponder()
      return false
    } else if clearField {
      textView.text = text
      clearField = false
      return true
    } else {
      return true
    }
  }
}
