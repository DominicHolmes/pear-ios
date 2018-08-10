//
//  PryntViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/9/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PryntViewController: UIViewController {
    
    var user: PryntUser?
    
    // Dismiss Keyboard
    @IBAction func dismissKeyboard(sender: UITapGestureRecognizer) { self.view.endEditing(true) }
    @IBAction func textFieldPrimaryActionShouldDismissKeyboard(sender: UITextField) { dismissKeyboard() }
    func dismissKeyboard() { self.view.endEditing(true) }
}
