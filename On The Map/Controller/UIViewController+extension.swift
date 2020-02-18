//
//  UIViewController+extension.swift
//  On The Map
//
//  Created by Ivan Hadzhiiliev on 2020-02-18.
//  Copyright © 2020 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showError(title: String, message: String?) {
        let alertVC = UIAlertController(title: title, message: message ?? "Something went wrong!", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
}
