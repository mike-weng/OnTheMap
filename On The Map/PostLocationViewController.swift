//
//  PostLocationViewController.swift
//  On The Map
//
//  Created by Mike Weng on 1/7/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PostLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    var tapRecognizer: UITapGestureRecognizer? = nil
    var appDelegate: AppDelegate!

    override func viewDidLoad() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        locationTextField.delegate = self

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
    
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func findOnMapTouchUp(sender: AnyObject) {
        
        let geocoder:CLGeocoder = CLGeocoder()
        let location = locationTextField.text
        geocoder.geocodeAddressString(location!, completionHandler: {(placemarks, error) -> Void in
            
            if((error) != nil){
                self.appDelegate.showAlert(self, title: "Invalid Search String", message: "Please enter a valid search string")
            }
            if let placemark = placemarks?.first {
                let userCoordinates = placemark.location!.coordinate
                
                let linkViewController = self.storyboard?.instantiateViewControllerWithIdentifier("LinkViewController") as! LinkViewController
                
                linkViewController.userCoordinates = userCoordinates
                linkViewController.userMapString = location
                self.presentViewController(linkViewController, animated: false, completion: nil)
            }
        })
        
        
    }
    
}

extension PostLocationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}