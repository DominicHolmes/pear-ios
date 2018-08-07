//
//  PearViewController.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class PearViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    var activeUser: PearUser?
    
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func textFieldPrimaryActionShouldDismissKeyboard(sender: UITextField) {
        dismissKeyboard()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

class PearLoginViewController: PearViewController {
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


class PearRegistrationViewController: PearViewController {
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

class PearTableViewController: UITableViewController {
    var databaseRef: DatabaseReference!
    var activeUser: PearUser?
    
    func displayAlert(_ title: String, _ messageHeader: String, _ errors: [String]) {
        var message = messageHeader
        for eachError in errors {
            message += eachError
        }
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
