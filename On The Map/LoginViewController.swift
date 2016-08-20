//
//  ViewController.swift
//  On The Map
//
//  Created by Mike Weng on 1/5/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    var appDelegate: AppDelegate!
    var activityIndicatorView : UIActivityIndicatorView!
    @IBOutlet weak var facebookLoginButton: FBSDKLoginButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var tapRecognizer: UITapGestureRecognizer? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        createActivityIndicatorView()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        facebookLoginButton.delegate = self
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.removeGestureRecognizer(tapRecognizer!)
    }

    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func usernameLoginTouchUp(sender: UIButton) {
        activityIndicatorView.startAnimating()
        UdacityClient.sharedInstance().authenticateWithViewController(self, completionHandler: { (success, error) in
            if success {
                UdacityClient.sharedInstance().getUserData({ (success, userInfo, error) in
                    if success {
                        StudentLocation.userLocation.firstName = userInfo!["first_name"] as! String
                        StudentLocation.userLocation.lastName = userInfo!["last_name"] as! String
                        StudentLocation.userLocation.uniqueKey = userInfo!["key"] as! String
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.appDelegate.showAlert(self, title: error!, message: "Invalid Username/Password!")
                        })
                    }
                })
                self.completeLogin()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.showAlert(self, title: error!, message: "Invalid Username/Password!")
                })
            }
        })
    }
    @IBAction func signUpTouchUp(sender: UIButton) {
        let url = NSURL(string: "https://www.udacity.com/account/auth#!/signin")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    func completeLogin() {
        ParseClient.sharedInstance().getStudentLocation({ (success, studentLocations, errorString) in
            if success {
                StudentLocation.studentLocations = studentLocations!
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicatorView.stopAnimating()
                    let controller = self.storyboard?.instantiateViewControllerWithIdentifier("MapTabBarController") as! UITabBarController
                    self.presentViewController(controller, animated: true, completion: nil)
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.showAlert(self, title: "Failed to get Student Data", message: "Unable to get data from Parse")
                })
            }
        })
    }
    
    func createActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicatorView?.center = self.view.center
        activityIndicatorView?.color = UIColor.grayColor()
        self.view.addSubview(activityIndicatorView!)
    }

}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

extension LoginViewController: FBSDKLoginButtonDelegate {
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        UdacityClient.sharedInstance().authenticateWithFacebook(result.token.tokenString, completionHandler: { (success, error) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicatorView.startAnimating()
                })
                UdacityClient.sharedInstance().getUserData({ (success, userInfo, error) in
                    if success {
                        StudentLocation.userLocation.firstName = userInfo!["first_name"] as! String
                        StudentLocation.userLocation.lastName = userInfo!["last_name"] as! String
                        StudentLocation.userLocation.uniqueKey = userInfo!["key"] as! String
                    } else {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.appDelegate.showAlert(self, title: error!, message: "Unable to get user data")
                        })
                    }
                })
                self.completeLogin()
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.showAlert(self, title: error!, message: "Invalid Username/Password!")
                })
            }
        })
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    }
}

