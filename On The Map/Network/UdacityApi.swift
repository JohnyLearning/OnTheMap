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
        
        case session
        case studentLocations(Int, Int, String, String)
        case createStudentLocation
        
        var stringValue: String {
            switch self {
            case .session: return Endpoints.base + "/session"
            case .studentLocations(let limit, let skip, let order, let uniqueKey):
                return Endpoints.base + "/StudentLocation?limit=\(limit)&skip=\(skip)&order=\(order)&uniqueKey=\(uniqueKey)"
            case .createStudentLocation: return Endpoints.base + "/StudentLocation"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func createSession(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let body = SessionRequest(udacity: LoginCredentials(username: username, password: password))
        taskForPOSTRequest(url: Endpoints.session.url, responseType: SessionResponse.self, body: body) { response, error in
            if let response = response {
                if response.account.registered {
                    completion(true, nil)
                }
            } else {
                completion(false, error)
            }
        }
    }
    
    class func deleteSession() {
        var request = URLRequest(url: Endpoints.session.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
          if error != nil { // Handle error…
              return
          }
          let range = 5..<data!.count
          let newData = data?.subdata(in: range) /* subset response data! */
          print(String(data: newData!, encoding: .utf8)!)
        }
        task.resume()
    }

    class func getStudentLocations(limit: Int = 100, skip: Int = 0, order: String = "-updatedAt", uniqueKey: String = "", completion: @escaping (StudentLocationsResponse?, Error?) -> Void) {
        taskForGETRequest(url: Endpoints.studentLocations(limit, skip, order, uniqueKey).url, responseType: StudentLocationsResponse.self) { response, error in
            if let response = response {
                completion(response, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
    class func createStudentLocation(studentInformation: StudentInformation, completion: @escaping (String?, Error?) -> Void) {
        UdacityApi.taskForPOSTRequest(url: Endpoints.createStudentLocation.url, responseType: CreateStudentLocationResponse.self, body: studentInformation) { response, error in
            if let response = response {
                completion(response.objectId, nil)
            } else {
                completion(nil, error)
            }
        }
    }
    
}
