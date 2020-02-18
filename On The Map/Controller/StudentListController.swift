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
        getStudentLocations()
    }
    
    @IBAction func refresh(_ sender: Any) {
        getStudentLocations()
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityApi.deleteSession()
        self.tabBarController?.dismiss(animated: true, completion: nil)
    }
    
    
    private func getStudentLocations() {
        UdacityApi.getStudentLocations() { studentLocationsResponse, error in
            if let studentLocations: [StudentInformation] = studentLocationsResponse?.results {
                self.usersData = studentLocations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.showError(title: "List Load Failed", message: error?.localizedDescription ?? "Something went wrong!")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentInfoCell") as! StudentCell
        
        let studentInformation = usersData?[indexPath.row]
        
        cell.firstLastName?.text = "\(studentInformation?.firstName ?? "No name") \(studentInformation?.lastName ?? "")"
        cell.link?.text = studentInformation?.mediaURL ?? "No url provided"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentInfo = usersData?[indexPath.row]
        if let url = URL(string: studentInfo?.mediaURL! ?? "") {
            UIApplication.shared.open(url, options: [:]) { result in
                if !result {
                    self.showError(title: "Open URL", message: "Open URL Failed: \(studentInfo?.mediaURL ?? "")")
                }
            }
        } else {
            showError(title: "Open URL", message: "Open URL Failed due to empty url")
        }
    }
}
