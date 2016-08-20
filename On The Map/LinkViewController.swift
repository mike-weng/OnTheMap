//
//  LinkViewController.swift
//  On The Map
//
//  Created by Mike Weng on 1/7/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class LinkViewController: UIViewController {
    
    var userCoordinates: CLLocationCoordinate2D!
    var userMapString: String!
    var pointAnnotation: MKPointAnnotation!
    var appDelegate: AppDelegate!
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        linkTextField.delegate = self
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        pointAnnotation = MKPointAnnotation()
         let span = MKCoordinateSpanMake(1, 1)
        var region = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        region = MKCoordinateRegion(center: userCoordinates, span: span)
        mapView.setRegion(region, animated: true)
        self.mapView?.addAnnotation(pointAnnotation)
    }
    @IBAction func submitButtonTouchUp(sender: AnyObject) {
        StudentLocation.userLocation.latitude = self.userCoordinates.latitude
        StudentLocation.userLocation.longitude = self.userCoordinates.longitude
        StudentLocation.userLocation.mapString = self.userMapString
        StudentLocation.userLocation.mediaURL = self.linkTextField.text!
        
        if StudentLocation.postedUserLocations.isEmpty == true {
            ParseClient.sharedInstance().postStudentLocation(StudentLocation.userLocation, completionHandler: { (success, updatedAt, error) in
                if success {
                    print(updatedAt)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    })
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.appDelegate.showAlert(self, title: "Invalid Link", message: "Please enter a valid link")
                    })
                }
            })
        } else {
            ParseClient.sharedInstance().putStudentLocation(StudentLocation.userLocation, completionHandler: { (success, updatedAt, error) in
                if success {
                    print(updatedAt)
                    dispatch_async(dispatch_get_main_queue(), {
                        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                    })                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        self.appDelegate.showAlert(self, title: "Invalid Link", message: "Please enter a valid link")
                    })
                }
            })
        }

        
    }
    
    @IBAction func cancelButtonTouchUp(sender: AnyObject) {
        self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension LinkViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}