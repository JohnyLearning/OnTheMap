//
//  StudentInformation.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    
    var createdAt: String?
    var firstName: String? = "Johny"
    var lastName: String? = "Bravo"
    var latitude: Double? = 0.0
    var longitude: Double? = 0.0
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String? = "1234567890"
    var updatedAt: String?
    
}

extension StudentInformation {
    
    init(mapString: String, mediaURL: String) {
        self.mapString = mapString
        self.mediaURL = mediaURL
    }
    
}
