//
//  UdacityConvenience.swift
//  On The Map
//
//  Created by Mike Weng on 1/5/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation
import UIKit

extension UdacityClient {
    func authenticateWithViewController(hostViewController: LoginViewController, completionHandler: (success: Bool, errorString: String?) -> Void) {
        UdacityClient.sharedInstance().getSession("mikewung@hotmail.com", password: "m84k512m", completionHandler: { (success, sessionID, userID, errorString) in
            if success {
                self.sessionID = sessionID
                self.userID = userID
            }
            completionHandler(success: success, errorString: errorString)
        })
    }
    
    func authenticateWithFacebook(accessToken:String, completionHandler: (success: Bool, errorString: String?) -> Void) {
        UdacityClient.sharedInstance().getSessionWithFacebook(accessToken, completionHandler: { (success, sessionID, userID, errorString) in
            if success {
                self.sessionID = sessionID
                self.userID = userID
            }
            completionHandler(success: success, errorString: errorString)
        })
    }
    
    func getUserData(completionHandler: (success: Bool, userInfo: [String:AnyObject]?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let methodParameters = [String : AnyObject]()
        var method = Methods.Users
        method = UdacityClient.substituteKeyInMethod(method, key: URLKeys.UserID, value: UdacityClient.sharedInstance().userID!)!
        
        
        /* 2. Make the request */
        taskForGETMethod(method, parameters: methodParameters, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, userInfo: nil, errorString: "Login Failed (Get User Data).")
                return
            }
            /* GUARD: Is the "result" key in result? */
            guard let userInfo = result[UdacityClient.JSONResponseKeys.User] as? [String:AnyObject] else {
                print("Could not find \(UdacityClient.JSONResponseKeys.User) in \(result)")
                completionHandler(success: false, userInfo: nil, errorString: "Login Failed (Get User Data).")
                return
            }
        
            completionHandler(success: true, userInfo: userInfo, errorString: nil)
            
        })
        
        print("implement me: UdacityClient getUserData")
        
    }
    
    func getSession( username: String, password: String, completionHandler: (success: Bool, sessionID: String?, userID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let methodParameters = [String : AnyObject]()
        let method = Methods.Session
        
        let jsonBody: [String : AnyObject] = [
            UdacityClient.JSONBodyKeys.Udacity : [
                UdacityClient.JSONBodyKeys.Username : username,
                UdacityClient.JSONBodyKeys.Password : password
            ]
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, parameters: methodParameters, jsonBody: jsonBody, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID)")
                return
            }
            
            
            /* GUARD: Is the "session_id" key in result? */
            guard let account = result[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject] else {
                print("Could not find \(UdacityClient.JSONResponseKeys.Account) in \(result)")
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (User ID).")
                return
            }
            
            guard let session = result[UdacityClient.JSONResponseKeys.Session] as? [String : String] else {
                print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(result)")
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID).")
                return
            }
            
            completionHandler(success: true, sessionID: session[UdacityClient.JSONResponseKeys.ID], userID: account[UdacityClient.JSONResponseKeys.Key] as? String, errorString: nil)
            
        })
        
        print("implement me: UdacityClient getSession")
        
    }
    
    func getSessionWithFacebook( accessToken: String, completionHandler: (success: Bool, sessionID: String?, userID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let methodParameters = [String : AnyObject]()
        let method = Methods.Session
        
        let jsonBody: [String : AnyObject] = [
            UdacityClient.JSONBodyKeys.FacebookMobile : [
                UdacityClient.JSONBodyKeys.AccessToken : accessToken
                ]
        ]
        
        /* 2. Make the request */
        taskForPOSTMethod(method, parameters: methodParameters, jsonBody: jsonBody, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID)")
                return
            }
            
            
            /* GUARD: Is the "session_id" key in result? */
            guard let account = result[UdacityClient.JSONResponseKeys.Account] as? [String : AnyObject] else {
                print("Could not find \(UdacityClient.JSONResponseKeys.Account) in \(result)")
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (User ID).")
                return
            }
            
            guard let session = result[UdacityClient.JSONResponseKeys.Session] as? [String : String] else {
                print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(result)")
                completionHandler(success: false, sessionID: nil, userID: nil, errorString: "Login Failed (Session ID).")
                return
            }
            
            completionHandler(success: true, sessionID: session[UdacityClient.JSONResponseKeys.ID], userID: account[UdacityClient.JSONResponseKeys.Key] as? String, errorString: nil)
            
        })
        
        print("implement me: UdacityClient getSessionWithFacebook")
        
    }

    
    func deleteSession(completionHandler: (success: Bool, sessionID: String?, errorString: String?) -> Void) {
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        let methodParameters = [String : AnyObject]()
        let method = Methods.Session
        
        
        /* 2. Make the request */
        taskForDELETEMethod(method, parameters: methodParameters, completionHandler: { (result, error) in
            
            /* 3. Send the desired value(s) to completion handler */
            guard error == nil else {
                completionHandler(success: false, sessionID: nil, errorString: "Logout Failed (Session ID)")
                return
            }
            
            
            /* GUARD: Is the "session_id" key in result? */
            guard let session = result[UdacityClient.JSONResponseKeys.Session] as? [String : String] else {
                print("Could not find \(UdacityClient.JSONResponseKeys.Session) in \(result)")
                completionHandler(success: false, sessionID: nil, errorString: "Logout Failed (Session ID).")
                return
            }
            
            completionHandler(success: true, sessionID: session[UdacityClient.JSONResponseKeys.ID], errorString: nil)
                
        })
        
        print("implement me: UdacityClient deleteSession")

    }
    
    
    
}