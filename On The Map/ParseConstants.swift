//
//  ParseConstants.swift
//  On The Map
//
//  Created by Mike Weng on 1/7/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation

extension ParseClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURLSecure : String = "https://api.parse.com/1/classes/"
        static let ApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let StudentLocation = "StudentLocation"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let UniqueKey = "uniqueKey"
        static let LastName = "lastName"
        static let FirstName = "firstName"
        static let MediaURL = "mediaURL"
        static let MapString = "mapString"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        static let Results = "results"
        static let ObjectID = "objectId"
        static let UpdatedAt = "updatedAt"
    }
}