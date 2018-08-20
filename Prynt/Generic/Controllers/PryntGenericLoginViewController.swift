//
//  PryntGenericLoginViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/19/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PryntLoginViewController: PryntViewController {
    func displayAlert(with errors: [String]) {
        var message = ""
        for eachError in errors {
            message += eachError
        }
        let alert = UIAlertController(title: "Unable to Login",
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
