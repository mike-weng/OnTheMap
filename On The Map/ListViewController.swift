//
//  ListViewController.swift
//  On The Map
//
//  Created by Mike Weng on 1/6/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit


class ListViewController: UIViewController{
    
    @IBOutlet weak var listTableView: UITableView!
    var appDelegate: AppDelegate!
    var activityIndicatorView : UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.createActivityIndicatorView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadData()
    }
    
    @IBAction func addLocationTouchUp(sender: AnyObject) {
        ParseClient.sharedInstance().queryStudentLocation({ (success, postedUserLocations, errorString) in
            if success {
                StudentLocation.postedUserLocations = postedUserLocations!
                dispatch_async(dispatch_get_main_queue(), {
                    self.checkForOverwrite()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.showAlert(self, title: errorString!, message: "Unable to retrieve data")
                })
                
            }
        })
        
    }
    
    func checkForOverwrite() {
        if StudentLocation.postedUserLocations.isEmpty == false {
            let message = "User \(StudentLocation.userLocation.firstName) \(StudentLocation.userLocation.lastName) has already posted a student location. Would you like to overwrite it?"
            self.appDelegate.showOverwriteAlert(self, title: "", message: message, handler: { (action) in
                self.showPostLocationView()
            })
        } else {
            self.showPostLocationView()
        }
    }
    
    func showPostLocationView() {
        let postLocationViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PostLocationViewController") as! PostLocationViewController
        self.presentViewController(postLocationViewController, animated: true, completion: nil)
    }

    @IBAction func refreshTouchUp(sender: UIBarButtonItem) {
        self.reloadData()
    }
    
    func reloadData() {
        activityIndicatorView.startAnimating()
        ParseClient.sharedInstance().getStudentLocation({ (success, studentLocations, error) in
            if success {
                
                StudentLocation.studentLocations = studentLocations!
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicatorView.stopAnimating()
                    self.listTableView.reloadData()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.showAlert(self, title: "Reload Failed", message: "Unable to retrieve data")
                })
            }
        })
    }
    
    @IBAction func logoutButtonTouchUp(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        self.activityIndicatorView.startAnimating()
        UdacityClient.sharedInstance().deleteSession({ (success, sessionID, error) in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicatorView.stopAnimating()
                    self.dismissViewControllerAnimated(true, completion: nil)
                })
            } else {
                print(error)
            }
        })
    }
    
    func createActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicatorView?.center = self.view.center
        activityIndicatorView?.color = UIColor.grayColor()
        self.listTableView.addSubview(activityIndicatorView!)
    }
    
    
}



extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as UITableViewCell!
        
        cell.textLabel?.text = studentLocation.firstName + " " + studentLocation.lastName
        cell.imageView?.image = UIImage(named: "pin")
        cell.detailTextLabel?.text = studentLocation.mapString
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let studentLocation = StudentLocation.studentLocations[indexPath.row]
        let urlString = studentLocation.mediaURL
        let url = NSURL(string: urlString)
        
        if UIApplication.sharedApplication().canOpenURL(url!) {
            UIApplication.sharedApplication().openURL(url!)
        } else {
            self.appDelegate.showAlert(self, title: "URL Error", message: "Invalid URL")
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocation.studentLocations.count
    }
}