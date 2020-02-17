//
//  LoginViewController.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-14.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func login(_ sender: Any) {
        setLoggingIn(true)
        let email = self.email.text ?? ""
        let password = self.password.text ?? ""
        
        UdacityApi.createSession(username: email, password: password, completion: self.handleSessionResponse(result:error:))
        
    }
    
    func handleSessionResponse(result: Bool, error: Error?) {
        setLoggingIn(false)
        if result {
            if let studentLookupTabBar = self.storyboard?.instantiateViewController(withIdentifier: "StudentTabBar") {
                self.view.window?.rootViewController = studentLookupTabBar
            }
        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    private func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        email.isEnabled = !loggingIn
        password.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    private func showLoginFailure(message: String) {
        setLoggingIn(false)
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        show(alertVC, sender: nil)
    }
        
}

