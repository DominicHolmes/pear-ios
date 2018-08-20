//
//  RadialCircleImageView.swift
//  Prynt
//
//  Created by Dominic Holmes on 2/28/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class RadialProgressView : UIView {
    
    let progressCircleLayer : CAShapeLayer!
    
    let progressStroke: UIColor = .green
    let progressFill: UIColor = .clear
    
    // Circle line thickness
    let lineWidth: CGFloat = 8.0
    
    // Between 0 and 1, denotes how much of circle is filled
    var progress: CGFloat = 0.0
    
    // Used to stop radial view from animating more than once (has the effect of seeming to instantly fill)
    var targetProgress: CGFloat = 0.0
    
    override init(frame: CGRect) {
        progressCircleLayer = CAShapeLayer()
        
        super.init(frame: frame)
        
        createCircles()
    }
    
    required init?(coder aDecoder: NSCoder) {
        progressCircleLayer = CAShapeLayer()
        
        super.init(coder: aDecoder)
        
        createCircles()
    }
    
    func createCircles() {
        // Create path (includes entire circle)
        // Careful messing with start/end angle and clockwise
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(
                x: frame.size.width / 2.0,
                y: frame.size.height / 2.0),
            radius: (frame.size.width - 10) / 2,
            startAngle: CGFloat(Double.pi * -0.5),
            endAngle: CGFloat(Double.pi * -2.5),
            clockwise: false)
        
        // Set up progressCircleLayer with the path, color, and line width
        progressCircleLayer.path = circlePath.cgPath
        progressCircleLayer.fillColor = progressFill.cgColor
        progressCircleLayer.strokeColor = progressStroke.cgColor
        progressCircleLayer.lineWidth = lineWidth
        
        // Initially draw current progress
        progressCircleLayer.strokeEnd = progress
        
        // Add progressCircleLayer to the view's CoreAnimations layer
        layer.addSublayer(progressCircleLayer)
    }
    
    func setValueAnimated(duration: TimeInterval, newProgressValue: CGFloat) {
        // Animate the strokeEnd property of the progressCircleLayer
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        
        // From start value to end value (0 to 1)
        animation.fromValue = progress
        animation.toValue = newProgressValue
        
        // Uncomment your preferred animation style ->
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        //animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        
        // Ensures strokeEnd property is the right value when animation ends
        progressCircleLayer.strokeEnd = newProgressValue
        self.progress = newProgressValue
        
        // Add the animation
        progressCircleLayer.add(animation, forKey: "animateCircle")
    }
    
}
