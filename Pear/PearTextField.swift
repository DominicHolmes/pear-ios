//
//  PearTextField.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PearTextField: UITextField {
    
    private let borderStroke = UIColor.pearGreen.cgColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Create path
        let path: UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.maxY))
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
        
    }

}
