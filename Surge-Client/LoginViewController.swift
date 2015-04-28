//
//  LoginViewController.swift
//  Surge-Client
//
//  Created by Manuel Sanchez Munoz on 4/27/15.
//  Copyright (c) 2015 Team-Surge. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
  let appDelegate = UIApplication.sharedApplication().delegate!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func loginAction(sender: UIButton) {
    // TODO: - Actually log the user in. For now we just go to the
    // main tab view
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let initialViewController = storyboard.instantiateInitialViewController() as! UIViewController
    appDelegate.window!.rootViewController = initialViewController
    
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
