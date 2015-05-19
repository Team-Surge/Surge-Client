//
//  RegisterViewController.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/27/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class RegisterViewController: UIViewController {
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var reenterPasswordField: UITextField!
  @IBOutlet weak var registerSpinner: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func hasValidRegistrationInput() -> Bool {
    if passwordField.text != reenterPasswordField.text {
      SurgeToast.showError("Passwords do not match", onCompletion: ({ _ in}))
      return false
    }
    return true
  }

  @IBAction func registerAction(sender: UIButton) {
    var request = HTTPTask()
    let params: [String:AnyObject] = [
      "action":"userCreate",
      "email":emailField.text,
      "password":passwordField.text
    ]
    
    if hasValidRegistrationInput() == false {
      return
    }
    
    registerSpinner.startAnimating()
    
    request.POST("http://surge.seektom.com/auth", parameters: params,
      success: {(response: HTTPResponse) in
        let jsonResponse = RegisterResponse(JSONDecoder(response.responseObject!))
        if jsonResponse.success! == true {
          dispatch_async(dispatch_get_main_queue(), {
            SurgeToast.showSuccess("Successfully registered", onCompletion: ({_ in}))
            self.dismissViewControllerAnimated(true, completion: nil)
          })
        } else {
          dispatch_async(dispatch_get_main_queue(), {
            self.registerSpinner.stopAnimating()
            SurgeToast.showError("Registration failure", onCompletion: ({_ in}))
          })
        }
      }, failure: {(error: NSError, response: HTTPResponse?) in
      
      })
    
  }
  
  @IBAction func backToLoginAction(sender: UIButton) {
    self.dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
    reenterPasswordField.resignFirstResponder()
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
  }
  */

}
