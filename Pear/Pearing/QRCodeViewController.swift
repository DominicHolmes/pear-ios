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
    
    private func handle(_ transaction: PearPendingTransaction) {
        
    }
    
    private func approveTransaction(_ transaction: PearPendingTransaction) {
        
    }
    
    private func denyTransaction(_ transaction: PearPendingTransaction) {
        
    }
    
}

extension QRCodeViewController {
    func displayTransactionPrompt(_ transaction: PearPendingTransaction) {
        let alert = UIAlertController(title: "Pear Requested",
                                      message: "User is requesting to Pear with you.",
                                      preferredStyle: .alert)
        let approveAction = UIAlertAction(title: "Approve", style: .default, handler: { action in
            self.approveTransaction(transaction)
        })
        let denyAction = UIAlertAction(title: "Deny", style: .destructive, handler: { action in
            self.denyTransaction(transaction)
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
        if let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            return processedImage
        }
        return nil
    }
}
