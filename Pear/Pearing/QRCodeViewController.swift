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
    @IBOutlet weak var QRCodeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = userProfile {
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
    
    
    // https://www.hackingwithswift.com/example-code/media/how-to-create-a-qr-code
    func generateQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        guard let qrFilterOutput = qrFilter.outputImage?.transformed(by: transform) else { return nil }
        
        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil }
        colorInvertFilter.setValue(qrFilterOutput, forKey: "inputImage")
        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil }
        
        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        maskToAlphaFilter.setValue(outputInvertedImage, forKey: "inputImage")
        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil }
        
        /*colorClampFilter.setValue(CIVector(x: 1.0, y: 1.0, z: 1.0, w: 0.0), forKey: "inputMinComponents")
        colorClampFilter.setValue(CIVector(x: 1.0, y: 1.0, z: 1.0, w: 0.0), forKey: "inputMaxComponents")
        guard let outputCIImage = colorClampFilter.outputImage else { return nil }*/
        
        let context = CIContext()
        if let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            return processedImage
        }
        return nil
        
        /*
        let data = string.data(using: String.Encoding.ascii)
        
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 5, y: 5)
        guard let qrFilterOutput = qrFilter.outputImage?.transformed(by: transform) else { return nil }
        
        guard let colorClampFilter = CIFilter(name: "CIColorClamp") else { return nil }
        colorClampFilter.setValue(qrFilterOutput, forKey: "inputImage")
        colorClampFilter.setValue(CIVector(x: 1.0, y: 1.0, z: 1.0, w: 0.0), forKey: "inputMinComponents")
        colorClampFilter.setValue(CIVector(x: 1.0, y: 1.0, z: 1.0, w: 0.0), forKey: "inputMaxComponents")
        guard let outputCIImage = colorClampFilter.outputImage else { return nil }
        
        let context = CIContext()
        if let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            return processedImage
        }
        return nil
        */
        
        /*if let whiteOutput = colorClampFilter.outputImage {
         let extent = filterOutput.extent
         let cgImage =
         let cgImage : CGImage = createCGImage(filteredImage, fromRect: extent)
         let finalImage = UIImage(ciImage: finalOutput)
         return finalImage
         }
         
         let context = CIContext()
         
         if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
         let processedImage = UIImage(cgImage: cgimg)
         print(processedImage.size)
         }
         
         /* if let finalOutput = colorClampFilter.outputImage?.transformed(by: transform) {
         return UIImage(ciImage: finalOutput)
         }*/*/
    }
}
