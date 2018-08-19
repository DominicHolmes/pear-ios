//
//  PresentTransactionViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PresentTransactionViewController: PryntViewController {
    
    var transaction: Transaction! {
        didSet {
            self.qrCodeImage = generateQRCode(from: transaction.transaction.id)
        }
    }
    
    var qrCodeImage: UIImage?
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var QRCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        profileNameLabel.text = transaction.primaryProfile.profileName
        nameLabel.text = transaction.primaryProfile.usersName
        handleLabel.text = "@" + transaction.primaryProfile.handle
        QRCodeImageView?.image = qrCodeImage
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userDidSelectClose() {
        dismiss(animated: true, completion: nil)
    }
}

extension PresentTransactionViewController {
    
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
        
        // Optional: replace colors in the UIImage - change color with the UIImageView tint on storyboard
        let tintedImage = processedImage.withRenderingMode(.alwaysTemplate)
        
        return tintedImage
    }
}
