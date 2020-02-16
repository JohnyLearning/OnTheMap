//
//  StudentListController.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-16.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

class StudentListController: UIViewController {
    
    private var usersData: [StudentInformation]?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = UdacityApi.getStudentLocations() { studentLocationsResponse, error in
            if let studentLocations: [StudentInformation] = studentLocationsResponse?.results {
                self.usersData = studentLocations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
}

extension StudentListController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfoCell")!
        
        let studentInformation = usersData?[indexPath.row]
        
        cell.textLabel?.text = "\(studentInformation?.firstName ?? "No name") \(studentInformation?.lastName ?? "")"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedIndex = indexPath.row
//        performSegue(withIdentifier: "showDetail", sender: nil)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
