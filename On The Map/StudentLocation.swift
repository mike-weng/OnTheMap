//
//  StudentLocation.swift
//  On The Map
//
//  Created by Mike Weng on 1/7/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Movie

struct StudentLocation {
    
    // MARK: Properties
    static var studentLocations = [StudentLocation]()
    static var userLocation = StudentLocation()
    static var postedUserLocations = [StudentLocation]()
    
    var createdAt = ""
    var firstName = ""
    var lastName = ""
    var latitude: Double!
    var longitude: Double!
    var mapString = ""
    var mediaURL = ""
    var objectID = ""
    var uniqueKey = ""
    var updatedAt = ""
    
    // MARK: Initializers
    init() {
        createdAt = ""
        firstName = ""
        lastName = ""
        mapString = ""
        mediaURL = ""
        objectID = ""
        uniqueKey = ""
        updatedAt = ""
    }
    
    init(dictionary: [String : AnyObject]) {
        createdAt = dictionary["createdAt"] as! String
        firstName = dictionary["firstName"] as! String
        lastName = dictionary["lastName"] as! String
        latitude = dictionary["latitude"] as! Double
        longitude = dictionary["longitude"] as! Double
        mapString = dictionary["mapString"] as! String
        mediaURL = dictionary["mediaURL"] as! String
        objectID = dictionary["objectId"] as! String
        uniqueKey = dictionary["uniqueKey"] as! String
        updatedAt = dictionary["updatedAt"] as! String
    }
    
    static func studentLocationsFromResults(results: [[String : AnyObject]]) -> [StudentLocation] {
        
        var studentLocations = [StudentLocation]()

        /* Iterate through array of dictionaries; each Movie is a dictionary */
        for result in results {
            studentLocations.append(StudentLocation(dictionary: result))
        }
        
        return studentLocations
    }
    
    
}