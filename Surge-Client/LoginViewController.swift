//
//  LoginViewController.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/27/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit
import SwiftHTTP
import JSONJoy

class LoginViewController: UIViewController {
  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func goToInitialView() {
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let initialViewController = storyboard.instantiateInitialViewController() as! UIViewController
    appDelegate.window!.rootViewController = initialViewController
  }
  
  @IBAction func loginAction(sender: UIButton) {
    var request = HTTPTask()
    let params: [String:AnyObject] = [
      "action": "userLogin",
      "email": emailField.text,
      "password": passwordField.text
    ]
    
    loginSpinner.startAnimating()
    
    request.POST("http://surge.seektom.com/auth", parameters: params,
      success: {(response: HTTPResponse) in
        let jsonResponse = LoginResponse(JSONDecoder(response.responseObject!))
        if jsonResponse.success! == true {
          dispatch_async(dispatch_get_main_queue(), {
            self.goToInitialView()
          })
        } else {
          dispatch_async(dispatch_get_main_queue(), {
            self.loginSpinner.stopAnimating()
            SurgeToast.showError("Failed to login", onCompletion: {_ in})
          })
        }
      }, failure: {(error: NSError, response: HTTPResponse?) in
        dispatch_async(dispatch_get_main_queue(), {
          self.loginSpinner.stopAnimating()
        })
      })
  }
  
  override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
    super.touchesBegan(touches, withEvent: event)
    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()
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
