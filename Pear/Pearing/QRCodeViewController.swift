//
//  QRCodeViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class QRCodeViewController: PearViewController {
    
    var socialProfile: SocialProfile?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = activeUser {
            nameLabel.text = user.firstName + " " + user.lastName
            handleLabel.text = "@" + user.username
        }
        
        if let _ = socialProfile {
            profileNameLabel.text = socialProfile!.getName()
            let qrCodeImage = generateQRCode(from: socialProfile!.getProfileID())
            QRCodeImageView.image = qrCodeImage
            
            observePendingTransaction()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userDidSelectClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func observePendingTransaction() {
        let ref = databaseRef.child("pendingTransactions").child(socialProfile!.getProfileID())
        ref.observe(.value, with: { snapshot in
            if let _ = snapshot.value, let dict = snapshot.value as? Dictionary<String, Dictionary<String, String>> {
                for eachPendingTransaction in dict {
                    self.handle(PearPendingTransaction(of: eachPendingTransaction.value))
                }
            }
        })
    }
    
    private func handle(_ pendingTransaction: PearPendingTransaction) {
        if !pendingTransaction.isApproved() && !pendingTransaction.isDenied() {
            
            if let _ = pendingTransaction.primaryProfileID {
                loadPrimaryProfile(with: pendingTransaction)
            } else {
                displayTransactionPrompt(pendingTransaction, optionalProfile: nil)
            }
        }
    }
    
    private func loadPrimaryProfile(with pending: PearPendingTransaction) {
        guard let primaryProfileID = pending.primaryProfileID else { return }
        let ref = databaseRef.child("allSocialProfiles").child(primaryProfileID)
        ref.observe(.value) { (snapshot) in
            guard let _ = snapshot.value, let dict = snapshot.value as? Dictionary<String, String> else { return }
            let primaryProfile = SocialProfile(of: dict)
            self.displayTransactionPrompt(pending, optionalProfile: primaryProfile)
        }
    }
    
    private func approveTransaction(_ pendingTransaction: PearPendingTransaction) {
        
    }
    
    func updateSecondaryUserTransactions(_ pendingTransaction: PearPendingTransaction) {
        let ref = databaseRef.child("usersTransactions").child(activeUser!.id).child(pendingTransaction.transactionID)
        ref.setValue(pendingTransaction.getFirebaseEncoding()) // INCORRECT - SHOULD BE TRANSACTION NOT PENDINGTRANSACTION
    }
    
    private func denyTransaction(_ pendingTransaction: PearPendingTransaction) {
        
    }

    
}

extension QRCodeViewController {
    func displayTransactionPrompt(_ pendingTransaction: PearPendingTransaction, optionalProfile profile: SocialProfile?) {
        
        let message: String
        
        if let _ = profile {
            message = "User is requesting to Pear with you. They are sharing their \(profile!.getName()) profile."
        } else {
            message = "User is requesting to Pear with you. They are not sharing a profile."
        }
        
        let alert = UIAlertController(title: "Pear Requested",
                                      message: message,
                                      preferredStyle: .alert)
        let approveAction = UIAlertAction(title: "Approve", style: .default, handler: { action in
            self.approveTransaction(pendingTransaction)
        })
        let denyAction = UIAlertAction(title: "Deny", style: .destructive, handler: { action in
            self.denyTransaction(pendingTransaction)
        })
        alert.addAction(denyAction)
        alert.addAction(approveAction)
        present(alert, animated: true)
    }
}

extension QRCodeViewController {
    
    func generateQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        // Generate the QR code
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        guard let qrFilterOutput = qrFilter.outputImage?.transformed(by: transform) else { return nil }
        
        // Invert the colors
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil }
        colorInvertFilter.setValue(qrFilterOutput, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil }
        
        // Replace black with transparency
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil }
        
        // Create gcImage from the extent
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else { return nil }
        let processedImage = UIImage(cgImage: cgImage)
        return processedImage
    }
}
