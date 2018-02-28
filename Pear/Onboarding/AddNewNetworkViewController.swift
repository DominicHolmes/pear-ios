//
//  AddNewNetworkViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class AddNewNetworkViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userDidSelectDelete() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func userDidSelectCancel() {
        dismiss(animated: true, completion: nil)
    }
}
