//
//  ViewAccountViewController.swift
//  Prynt
//
//  Created by Dominic Holmes on 8/10/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

protocol ViewAccountViewControllerDelegate {
    func viewAccountViewControllerDidCancel(_ controller: ViewAccountViewController)
    func viewAccountViewControllerDidCreate(_ controller: ViewAccountViewController, account: Account)
    func viewAccountViewControllerDidUpdate(_ controller: ViewAccountViewController, account: Account)
    func viewAccountViewControllerDidDelete(_ controller: ViewAccountViewController, account: Account)
}

class ViewAccountViewController: PearViewController {
    
    var delegate: ViewAccountViewControllerDelegate?
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
        delegate?.viewAccountViewControllerDidCancel(self)
    }
    
    @IBAction func userDidSelectCancel() {
        delegate?.viewAccountViewControllerDidCancel(self)
    }
}
