//
//  QRCodeViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class QRCodeViewController: UIViewController {
    
    var socialProfile: SocialProfile?
    var userProfile: PearUser?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = userProfile {
            nameLabel.text = user.firstName + " " + user.lastName
            handleLabel.text = user.username
        }
        if let _ = socialProfile {
            profileNameLabel.text = socialProfile!.getName()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userDidSelectClose() {
        dismiss(animated: true, completion: nil)
    }
}
