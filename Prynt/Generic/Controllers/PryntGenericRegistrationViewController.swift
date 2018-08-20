//
//  PryntRegistrationViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/19/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PryntGenericRegistrationViewController: PryntViewController {
    func displayAlert(_ title: String, _ messageHeader: String, _ errors: [String], _ shouldSegue: Bool) {
        var message = messageHeader
        for eachError in errors {
            message += eachError
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if shouldSegue {
            let action = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.performSegue(withIdentifier: "PryntRegistrationSegue", sender: self)
            })
            alert.addAction(action)
            present(alert, animated: true)
        } else {
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
}
