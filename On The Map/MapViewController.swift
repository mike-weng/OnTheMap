//
//  MapViewController.swift
//  On The Map
//
//  Created by Mike Weng on 1/6/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import FBSDKLoginKit



class MapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    var studentLocations = [StudentLocation]()
    var annotations = [MKPointAnnotation]()
    var appDelegate: AppDelegate!
    var activityIndicatorView : UIActivityIndicatorView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.resetAnnotations()
        self.createActivityIndicatorView()
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
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
    
    func reloadData() {
        activityIndicatorView.startAnimating()
        ParseClient.sharedInstance().getStudentLocation({ (success, studentLocations, error) in
            if success {
                StudentLocation.studentLocations = studentLocations!
                dispatch_async(dispatch_get_main_queue(), {
                    self.activityIndicatorView.stopAnimating()
                    self.resetAnnotations()
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.appDelegate.showAlert(self, title: error!, message: "Unable to get StudentLocations")
                })
            }
        })
        mapView.reloadInputViews()
    }
    
    func resetAnnotations() {
        self.mapView.removeAnnotations(self.annotations)
        self.annotations = []
        
        for dictionary in StudentLocation.studentLocations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            self.annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
    }
    
    func createActivityIndicatorView() {
        activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        activityIndicatorView?.center = self.view.center
        activityIndicatorView?.color = UIColor.grayColor()
        self.mapView.addSubview(activityIndicatorView)
    }
    
}

extension MapViewController: MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }

    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                let url = NSURL(string: toOpen)!
                if app.canOpenURL(url) {
                    app.openURL(url)
                } else {
                    self.appDelegate.showAlert(self, title: "URL Error", message: "Invalid URL")
                }
            }
        }
    }
    
}