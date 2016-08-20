//
//  ParseConvenience.swift
//  On The Map
//
//  Created by Mike Weng on 1/7/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit

extension ParseClient {
    
    func putStudentLocation( studentLocation: StudentLocation, completionHandler: (success: Bool, updatedAt: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let objectID = StudentLocation.postedUserLocations[0].objectID
        let method = Methods.StudentLocation
        
        let jsonBody: [String : AnyObject] = [
            ParseClient.JSONBodyKeys.UniqueKey : studentLocation.uniqueKey,
            ParseClient.JSONBodyKeys.FirstName : studentLocation.firstName,
            ParseClient.JSONBodyKeys.LastName : studentLocation.lastName,
            ParseClient.JSONBodyKeys.MapString : studentLocation.mapString,
            ParseClient.JSONBodyKeys.MediaURL : studentLocation.mediaURL,
            ParseClient.JSONBodyKeys.Latitude : studentLocation.latitude,
            ParseClient.JSONBodyKeys.Longitude : studentLocation.longitude
        ]
        
        /* 2. Make the request */
        taskForPUTMethod(method, objectID: objectID, jsonBody: jsonBody, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, updatedAt: nil, errorString: "Put Location Failed (Object ID).")
                return
            }
            
            /* GUARD: Is the "objectId" key in result? */
            guard let updatedAt = result[ParseClient.JSONResponseKeys.UpdatedAt] as? String else {
                print("Could not find \(ParseClient.JSONResponseKeys.UpdatedAt) in \(result)")
                completionHandler(success: false, updatedAt: nil, errorString: "Put Location Failed (Object ID).")
                return
            }
            completionHandler(success: true, updatedAt: updatedAt, errorString: nil)
            
        })
        
        print("implement me: ParseClient putStudentLocation")
        
    }


    func postStudentLocation( studentLocation: StudentLocation, completionHandler: (success: Bool, updatedAt: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let methodParameters = [String : AnyObject]()
        let method = Methods.StudentLocation
        
        let jsonBody: [String : AnyObject] = [
            ParseClient.JSONBodyKeys.UniqueKey : studentLocation.uniqueKey,
            ParseClient.JSONBodyKeys.FirstName : studentLocation.firstName,
            ParseClient.JSONBodyKeys.LastName : studentLocation.lastName,
            ParseClient.JSONBodyKeys.MapString : studentLocation.mapString,
            ParseClient.JSONBodyKeys.MediaURL : studentLocation.mediaURL,
            ParseClient.JSONBodyKeys.Latitude : studentLocation.latitude,
            ParseClient.JSONBodyKeys.Longitude : studentLocation.longitude
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, parameters: methodParameters, jsonBody: jsonBody, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, updatedAt: nil, errorString: "Post Location Failed (Object ID).")
                return
            }
            
            /* GUARD: Is the "objectId" key in result? */
            guard let updatedAt = result[ParseClient.JSONResponseKeys.UpdatedAt] as? String else {
                print("Could not find \(ParseClient.JSONResponseKeys.UpdatedAt) in \(result)")
                completionHandler(success: false, updatedAt: nil, errorString: "Post Location Failed (Object ID).")
                return
            }
            completionHandler(success: true, updatedAt: updatedAt, errorString: nil)
            
        })
        
        print("implement me: ParseClient postStudentLocation")
        
    }
    
    func getStudentLocation(completionHandler: (success: Bool, results: [StudentLocation]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let methodParameters = [
            "limit" : "100",
            "order" : "-updatedAt"
        ]
        let method = Methods.StudentLocation
        
        
        /* 2. Make the request */
        taskForGETMethod(method, parameters: methodParameters, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, results: nil, errorString: "Get Location Failed (Student Location)")
                return
            }
            /* GUARD: Is the "result" key in result? */
            guard let results = result[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                print("Could not find \(ParseClient.JSONResponseKeys.Results) in \(result)")
                completionHandler(success: false, results: nil, errorString: "Get Location Failed (Student Location).")
                return
            }

            let studentLocations = StudentLocation.studentLocationsFromResults(results)
            completionHandler(success: true, results: studentLocations, errorString: nil)
            
        })
        
        print("implement me: ParseClient getStudentLocation")
        
    }
    
    func queryStudentLocation(completionHandler: (success: Bool, results: [StudentLocation]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let methodParameters = [
            "where" : "{\"uniqueKey\":\"\(StudentLocation.userLocation.uniqueKey)\"}"
        ]
        
        let method = Methods.StudentLocation
        
        /* 2. Make the request */
        taskForGETMethod(method, parameters: methodParameters, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, results: nil, errorString: "Query Location Failed (Student Location)")
                return
            }
            /* GUARD: Is the "result" key in result? */
            guard let results = result[ParseClient.JSONResponseKeys.Results] as? [[String:AnyObject]] else {
                print("Could not find \(ParseClient.JSONResponseKeys.Results) in \(result)")
                completionHandler(success: false, results: nil, errorString: "Query Location Failed (Student Location).")
                return
            }

            let postedUserLocations = StudentLocation.studentLocationsFromResults(results)
            completionHandler(success: true, results: postedUserLocations, errorString: nil)
            
        })
        
        print("implement me: ParseClient queryStudentLocation")
        
    }
    
    
}