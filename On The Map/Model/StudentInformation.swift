//
//  StudentInformation.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Double
    let longitude:Double
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String
    let updatedAt: String
    
}
