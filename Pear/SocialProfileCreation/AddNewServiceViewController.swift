//
//  AddNewNetworkViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

protocol AddNewServiceProfileDelegate {
    func addNewServiceViewControllerDidCancel(_ controller: AddNewServiceViewController)
    func addNewServiceViewControllerDidSave(_ controller: AddNewServiceViewController,
                                            withService service: SocialService?)
}

class AddNewServiceViewController: PearViewController {
    
    var delegate: AddNewServiceProfileDelegate?
    var socialServiceType: SocialServiceType?
    var socialService: SocialService?
    
    @IBOutlet var handleTextField: UITextField!
    @IBOutlet var socialServiceNameLabel: UILabel!
    @IBOutlet var socialServiceLogo: UIImageView!
    @IBOutlet var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        if let service = socialServiceType {
            socialServiceNameLabel.text = "I want to share my \(service.serviceName)"
            socialServiceLogo.image = UIImage(named: service.photoName)
            handleTextField.placeholder = "\(service.serviceName) username"
        }
        if let _ = socialService {
            handleTextField.text = socialService!.handle
            doneButton.isEnabled = true
        }
    }
    
    @IBAction func doneButtonShouldUpdateState() {
        doneButton.isEnabled = handleTextField.hasText
    }
    
    @IBAction func userDidSelectDone() {
        delegate?.addNewServiceViewControllerDidSave(self, withService: SocialService(socialService: socialServiceType, handle: handleTextField.text!))
    }
    
    @IBAction func userDidSelectCancel() {
        delegate?.addNewServiceViewControllerDidCancel(self)
    }
}
