//
//  PostRegistrationViewController.swift
//  Pear
//
//  Created by dominic on 4/12/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PostRegistrationViewController : PearViewController {
    
    @IBAction func segueButtonPressed() {
        performSegue(withIdentifier: "CreateSocialProfileSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CreateSocialProfileSegue" {
            let controller = segue.destination as! CreateSocialProfileViewController
            controller.databaseRef = self.databaseRef
            controller.activeUser = self.activeUser
        }
    }
    
}
