//
//  NetworkCollectionCell.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import Foundation
import UIKit

class NetworkCollectionCell: UICollectionViewCell {
    
    private var checkmarkLayer: CAShapeLayer?
    
    lazy var checkmarkView: UIImageView? = self.viewWithTag(101) as? UIImageView
    
    var socialServiceType: SocialServiceType?
    var accountToEdit: Account?
    var accountToDisplay: Account?
    
    var isChecked = false {
        didSet {
            self.updateCheckmark()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func createCheckmark() {
        // Create path
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.maxX - 10, y: self.bounds.maxY - 10))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.maxY))
        
        // Create a CAShape Layer
        let pathLayer: CAShapeLayer = CAShapeLayer()
        pathLayer.frame = self.bounds
        pathLayer.path = path.cgPath
        pathLayer.strokeColor = UIColor.pearGreen.cgColor
        pathLayer.fillColor = nil
        pathLayer.lineWidth = 2.0
        pathLayer.lineJoin = kCALineJoinBevel
        
        // Add layer to views layer
        self.layer.addSublayer(pathLayer)
        
        // Basic Animation
        let pathAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pathAnimation.duration = 0.4
        pathAnimation.fromValue = 0.0
        pathAnimation.toValue = 1.0
        //pathAnimation.beginTime = CACurrentMediaTime() + 0.5
        
        // Add Animation
        pathLayer.add(pathAnimation, forKey: "strokeEnd")
        checkmarkLayer = pathLayer
    }
    
    private func updateCheckmark() {
        
        if isChecked {
            checkmarkView?.image = UIImage(named: "checkmark.png")
            /*
            createCheckmark()
            if let _ = checkmarkLayer {
                layer.addSublayer(checkmarkLayer!)
            }*/
        } else {
            checkmarkView?.image = nil
            /*
            checkmarkLayer?.removeFromSuperlayer()
            checkmarkLayer?.removeAllAnimations()
            checkmarkLayer = nil*/
        }
    }
    
}
