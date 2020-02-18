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
        _ = UdacityApi.getStudentLocations() { studentLocationsResponse, error in
            if let studentLocations: [StudentInformation] = studentLocationsResponse?.results {
                self.usersData = studentLocations
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                DispatchQueue.main.async {
                    self.showFailure(title: "List Load Failed", localizedMessage: error?.localizedDescription ?? "Something went wrong!")
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
                    self.showFailure(title: "Open URL", localizedMessage: "Open URL Failed: \(studentInfo?.mediaURL ?? "")")
                }
            }
        } else {
            showFailure(title: "Open URL", localizedMessage: "Open URL Failed due to empty url")
        }
    }
    
    private func showFailure(title: String, localizedMessage: String?) {
        let alertVC = UIAlertController(title: title, message: localizedMessage ?? "Something went wrong!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
}
