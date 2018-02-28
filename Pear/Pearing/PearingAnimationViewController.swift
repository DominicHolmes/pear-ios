//
//  PearingAnimationViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PearingAnimationViewController: UIViewController {
    
    var scannedCode : String?
    
    @IBOutlet weak var topProfileView : RadialProgressView!
    @IBOutlet weak var topProfileImageView : UIImageView!
    @IBOutlet weak var bottomProfileView : RadialProgressView!
    @IBOutlet weak var bottomProfileImageView : UIImageView!
    
    @IBOutlet weak var topProfileTrailingConstraint : NSLayoutConstraint!
    @IBOutlet weak var topProfileWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var bottomProfileLeadingConstraint : NSLayoutConstraint!
    @IBOutlet weak var bottomProfileWidthConstraint : NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutImageViewInitialPositions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupProfileImages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        beginPearingAnimation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension PearingAnimationViewController {
    
    private func layoutImageViewInitialPositions() {
        self.topProfileTrailingConstraint.constant = self.view.layer.bounds.maxX
        self.bottomProfileLeadingConstraint.constant = self.view.layer.bounds.maxX
        self.view.layoutIfNeeded()
    }
    
    private func setupProfileImages() {
        topProfileImageView.setRounded()
        bottomProfileImageView.setRounded()
    }
    
    private func beginPearingAnimation() {

        topProfileView.isHidden = false
        bottomProfileView.isHidden = false
        
        UIView.animate(
            withDuration: 0.3,
            animations: {
                self.topProfileTrailingConstraint.constant =
                    (self.view.layer.bounds.maxX / 2.0) - (self.topProfileWidthConstraint.constant / 2.0)
                self.bottomProfileLeadingConstraint.constant =
                    (self.view.layer.bounds.maxX / 2.0) - (self.bottomProfileWidthConstraint.constant / 2.0)
                self.view.layoutIfNeeded()
            },
            completion: { (true) in
                self.animatePearingCircles()
            })
    }
    
    private func animatePearingCircles() {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(0), execute: {
            self.topProfileView.setValueAnimated(duration: 0.6, newProgressValue: 1.0)
            self.bottomProfileView.setValueAnimated(duration: 0.6, newProgressValue: 1.0)
        })
    }
}
