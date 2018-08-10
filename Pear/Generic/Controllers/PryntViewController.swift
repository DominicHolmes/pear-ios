//
//  PryntViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PryntViewController: UIViewController {
    
    var user: PryntUser!
    
    // Dismiss Keyboard
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) { self.view.endEditing(true) }
    @IBAction func textFieldPrimaryActionShouldDismissKeyboard(sender: UITextField) { dismissKeyboard() }
    func dismissKeyboard() { self.view.endEditing(true) }
    
    // Generic Alert
    func displayAlert(_ title: String, _ messageHeader: String, _ errors: [String]?) {
        var message = messageHeader
        if errors != nil { for eachError in errors! { message += eachError }}
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
}
