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
            QRCodeImageView.image = generateQRCode(from: socialProfile!.getProfileID())
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
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 5, y: 5)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
