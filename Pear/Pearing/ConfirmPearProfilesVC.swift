//
//  PearingAnimationViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/27/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class ConfirmPearProfilesVC: PearViewController {
    
    var scannedCode : String? {
        didSet {
            if scannedCode != nil { self.searchForProfile(withId: scannedCode!) }
        }
    }
    
    var profileToShare : SocialProfile?
    var scannedProfile : SocialProfile?
    
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

extension ConfirmPearProfilesVC {
    func searchForProfile(withId profileId: String) {
        attemptLoadSocialProfile(with: profileId)
    }
    
    func attemptLoadSocialProfile(with id: String) {
        let profilesRef = databaseRef.child("allSocialProfiles").child(id)
        profilesRef.observe(.value, with: { snapshot in
            if let _ = snapshot.value {
                self.loadSocialProfile(ofId: id, withSnapshot: snapshot)
            }
            print("Done!!")
            //self.performSegue(withIdentifier: "LoginCompletionSegue", sender: nil)
        })
    }
    
    func loadSocialProfile(ofId profileId: String, withSnapshot snapshot: DataSnapshot) {
        var loadedProfile: SocialProfile
        
        if let profileDict = snapshot.value as? [String: String] {
            var loadedServices = [SocialService]()
            var profileName = "ProfileName"
            let profileId = profileId
            for service in profileDict {
                if service.key == "!ProfileName" {
                    profileName = service.value
                } else if service.key != "!ProfileId" {
                    let newService = SocialService(socialService: SocialServiceType(rawValue: service.key),
                                                   handle: SocialProfile.parseHandle(service.value),
                                                   ranking: SocialProfile.parseRanking(service.value))
                    loadedServices.append(newService)
                }
            }
            loadedProfile = SocialProfile(name: profileName, services: loadedServices)
            loadedProfile.setProfileID(id: profileId)
            dump(loadedProfile)
        }
    }
}

// Mark: - Pearing Animation
extension ConfirmPearProfilesVC {
    
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
