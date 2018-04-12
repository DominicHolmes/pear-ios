//
//  PearViewController.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase

class PearViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    var activeUser: PearUser?
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func displayAlert(_ title: String, _ messageHeader: String, _ errors: [String], _ toPayment: Bool) {
        var message = messageHeader
        for eachError in errors {
            message += eachError
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        if toPayment {
            let action = UIAlertAction(title: "OK", style: .default, handler: { action in
                self.performSegue(withIdentifier: "PostRegistrationSegue", sender: self)
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
