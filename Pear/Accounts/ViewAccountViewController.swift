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
    func viewAccountViewControllerDidCreate(_ controller: ViewAccountViewController, accountCreate: AccountCreate)
    func viewAccountViewControllerDidUpdate(_ controller: ViewAccountViewController, account: Account)
    func viewAccountViewControllerDidDelete(_ controller: ViewAccountViewController, account: Account)
}

class ViewAccountViewController: PearViewController {
    
    private enum State {
        case editing
        case viewing
        case creating
    }
    
    var delegate: ViewAccountViewControllerDelegate?
    var service: SocialServiceType!
    private var state = State.creating
    
    @IBOutlet var handleTextField: UITextField!
    @IBOutlet var socialServiceNameLabel: UILabel!
    @IBOutlet var socialServiceLogo: UIImageView!
    @IBOutlet var doneButton: UIButton!
    
    var accountToEdit: Account? {
        didSet {
            state = .editing
        }
    }
    var accountToDisplay: Account? {
        didSet {
            state = .viewing
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
        super.viewWillAppear(animated)
    }
    
    private func setupUI() {
        socialServiceLogo.image = UIImage(named: service.photoName)
        switch state {
        case .creating:
            socialServiceNameLabel.text = "I want to share my \(service.serviceName)"
            handleTextField.placeholder = "\(service.serviceName) username"
        case .editing:
            socialServiceNameLabel.text = "\(service.serviceName)"
            if let accountToEdit = accountToEdit {
                handleTextField.text = accountToEdit.handle
                handleTextField.isEnabled = true
                doneButton.isEnabled = true
            }
        case .viewing:
            socialServiceNameLabel.text = "\(service.serviceName)"
            if let accountToDisplay = accountToDisplay {
                handleTextField.text = accountToDisplay.handle
                handleTextField.isEnabled = false
                doneButton.isEnabled = true
            }
        }
    }
    
    @IBAction func doneButtonShouldUpdateState() {
        doneButton.isEnabled = handleTextField.hasText
    }
    
    @IBAction func userDidSelectDone() {
        switch state {
        case .viewing: delegate?.viewAccountViewControllerDidCancel(self)
        case .creating:
            if let text = handleTextField.text {
                delegate?.viewAccountViewControllerDidCreate(self, accountCreate: AccountCreate(service: service, handle: text))
            }
        case .editing:
            if let text = handleTextField.text, let accountToEdit = accountToEdit {
                delegate?.viewAccountViewControllerDidUpdate(self, account: Account(service: service, handle: text, id: accountToEdit.id))
            }
        }
    }
    
    @IBAction func userDidSelectCancel() {
        delegate?.viewAccountViewControllerDidCancel(self)
    }
}
