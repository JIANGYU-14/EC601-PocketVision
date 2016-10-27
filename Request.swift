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
    
    // MARK: Initialization
    
    init?(requester: String) {
        // Initialize stored properties.
        self.requester = requester
        
        // Initialization should fail if there is no name or if the rating is negative.
        if requester.isEmpty {
            return nil
        }
}
}
