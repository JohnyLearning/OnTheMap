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
    
    @IBAction func signUp(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)
    }
    
    
    private func handleSessionResponse(result: Bool, error: Error?) {
        setLoggingIn(false)
        if result {
            if let studentLookupTabBar = self.storyboard?.instantiateViewController(withIdentifier: "StudentTabBar") {
                studentLookupTabBar.modalPresentationStyle = .fullScreen
                self.present(studentLookupTabBar, animated: true)
            }

        } else {
            showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    private func setLoggingIn(_ loggingIn: Bool) {
        loggingIn ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
        email.isEnabled = !loggingIn
        password.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    private func showLoginFailure(message: String) {
        setLoggingIn(false)
        showError(title: "Login Failed", message: message)
    }
        
}

