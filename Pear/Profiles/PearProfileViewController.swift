//
//  ViewProfileViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/1/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PearProfileViewController: PearViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var socialProfile: SocialProfile? {
        didSet {
            if let _ = socialProfile?.getServices() {
                services = socialProfile!.getServices()!
                if services!.haveRankings() {
                    services = socialProfile?.getServices()?.sorted(by: { $0.ranking! < $1.ranking! })
                } else {
                    services = services?.assignRankings()
                    services = socialProfile?.getServices()?.sorted(by: { $0.ranking! < $1.ranking! })
                }
            }
        }
    }
    
    var services: [SocialService]?
    var shouldResetSegues = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func userDidSelectDone() {
        if shouldResetSegues {
            performSegue(withIdentifier: "returnToHomeSegue", sender: nil)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "returnToHomeSegue" {
            let navController = segue.destination as! UINavigationController
            let tabBarController = navController.topViewController as! PearTabBarController
            tabBarController.databaseRef = self.databaseRef
            tabBarController.activeUser = self.activeUser
        }
    }
}

// MARK: - CollectionView Data Source
extension PearProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let profile = socialProfile {
            return profile.getServices()?.count ?? 0
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell", for: indexPath) as? NetworkCollectionCell
        
        let cellImageView = cell!.viewWithTag(100) as? UIImageView
        if services != nil && indexPath.row < services!.count {
            let service = services![indexPath.row]
            cell?.socialService = service
            cell?.socialServiceType = service.socialService
            cellImageView?.image = UIImage(named: service.socialService.photoName)
        }
        
        return cell!
    }
}

// MARK: - CollectionView Delegate
extension PearProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let service : SocialService! = services![indexPath.row]
        let username = service.handle
        
        let appURLString = service!.socialService!.appURL + username!
        let webURLString = service!.socialService!.webURL + username!
        
        let appURL = NSURL(string: appURLString)!
        let webURL = NSURL(string: webURLString)!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
}
