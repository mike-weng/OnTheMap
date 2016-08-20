//
//  UdacityConstants.swift
//  On The Map
//
//  Created by Mike Weng on 1/5/16.
//  Copyright © 2016 Weng. All rights reserved.
//

import Foundation

extension UdacityClient {
    
    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let BaseURLSecure : String = "https://www.udacity.com/api/"
    }
    // MARK: Methods
    struct Methods {
        
        // MARK: Authentication
        static let Session = "session"
        static let Users = "users/{id}"
        
    }
    
    // MARK: URL Keys
    struct URLKeys {
        
        static let UserID = "id"
        
    }
    
    // MARK: JSON Body Keys
    struct JSONBodyKeys {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let FacebookMobile = "facebook_mobile"
        static let AccessToken = "access_token"

        
    }

    // MARK: JSON Response Keys
    struct JSONResponseKeys {

        // MARK: Authorization
        static let ID = "id"
        static let Key = "key"
        static let User = "user"
        static let Session = "session"
        static let Account = "account"
    }
}