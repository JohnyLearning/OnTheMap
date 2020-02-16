//
//  UdacityApi.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-15.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation

class UdacityApi: BaseApi {
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case createSession
        case studentLocations(Int, Int, String, String)
        
        var stringValue: String {
            switch self {
            case .createSession: return Endpoints.base + "/session"
            case .studentLocations(let limit, let skip, let order, let uniqueKey):
                return Endpoints.base + "/StudentLocation?limit=\(limit)&skip=\(skip)&order=\(order)&uniqueKey=\(uniqueKey)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func createSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: LoginCredentials(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.createSession.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                if response.account.registered {
                    completion(true, nil)
                }
            } else {
                completion(false, error)
            }
        }
    }

    class func getStudentLocations(limit: Int = 100, skip: Int = 0, order: String = "", uniqueKey: String = "", completion: @escaping (StudentLocationsResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocations(limit, skip, order, uniqueKey).url, responseType: StudentLocationsResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
