//
//  Extensions.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import UIKit

extension UINavigationBar {
    /*
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        let screenRect = UIScreen.main.bounds
        return CGSize(width: screenRect.size.width, height: 128)
    }*/
}

extension UIColor {
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static let pearGreen = UIColor(r: 0, g: 189, b: 157)
}

extension UIImageView {
    
    func setRounded() {
        let radius = self.frame.width / 2.0
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
}