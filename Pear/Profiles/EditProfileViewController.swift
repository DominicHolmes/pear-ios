//
//  EditProfileViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/13/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation

class EditProfileViewController: PryntViewController {
    
    @IBAction func didSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
    var profileToEdit: PryntProfile!
}
