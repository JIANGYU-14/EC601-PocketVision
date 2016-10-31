//
//  Request.swift
//  PocketVision
//
//  Created by Sherman Sze on 10/27/16.
//
//

import UIKit

class Request {
    
    // MARK: Properties
    
    var requester: String
    var latitude: Double
    var longitude: Double
    
    // MARK: Initialization
    
    init?(requester: String, latitude: Double, longitude: Double) {
        // Initialize stored properties.
        self.requester = requester
        self.latitude = latitude
        self.longitude = longitude
        
        // Initialization should fail if there is no name
        if requester.isEmpty {
            return nil
        }
}
    
}
