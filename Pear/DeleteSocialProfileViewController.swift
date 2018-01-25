//
//  DeleteSocialProfileViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 1/25/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class DeleteSocialProfileViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
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
