//
//  ProfileConstructionViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SocialProfileConstructionViewController: PearViewController {
    
    var allServices = SocialServiceType.allValues
    var enabledServices = [SocialService]()
    
    weak var lastTappedCell: NetworkCollectionCell?
    
    @IBOutlet weak var collectionView: UICollectionView!
    var socialProfile: SocialProfile!
    
    @IBAction func doneButtonTapped() {
        if enabledServices.count > 0 {
            saveNewSocialProfile()
        }
        //performSegue(withIdentifier: "ProfileConstructionCompletedSegue", sender: nil)
    }
    
    func saveNewSocialProfile() {
        
        if activeUser != nil && enabledServices.count > 0 {
            
            let newProfileRef: DatabaseReference!
            
            if socialProfile.hasProfileID() {
                newProfileRef = databaseRef.child("usersSocialProfiles").child(activeUser!.id).child(socialProfile.getProfileID())
            } else {
                newProfileRef = databaseRef.child("usersSocialProfiles").child(activeUser!.id).childByAutoId()
                socialProfile.setProfileID(id: newProfileRef.key)
            }
            socialProfile.setServices(services: enabledServices)
            newProfileRef.setValue(socialProfile.getFirebaseEncoding())
            
        }
    }
}

// MARK: - CollectionView Data Source
extension SocialProfileConstructionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell",
                                                      for: indexPath) as! NetworkCollectionCell
        let serviceType = allServices[indexPath.row]
        cell.socialServiceType = serviceType
        
        let enabledServicesOfSameType = enabledServices.filter { $0.socialService == serviceType }
        if !enabledServicesOfSameType.isEmpty {
            cell.socialService = enabledServicesOfSameType[0]
        }
        
        let cellImageView = cell.viewWithTag(100) as? UIImageView
        cellImageView?.image = UIImage(named: serviceType.photoName)
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension SocialProfileConstructionViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? NetworkCollectionCell
        
        if cell != nil && cell!.isChecked {
            cell!.isChecked = false
            if let service = cell!.socialService {
                enabledServices = enabledServices.filter { $0.socialService != service.socialService &&
                                                           $0.handle != service.handle}
            }
        } else if cell != nil && !cell!.isChecked {
            self.lastTappedCell = cell
            performSegue(withIdentifier: "addNetworkSegue", sender: cell)
        }
    }
}

// MARK: - Add New Network Popover
extension SocialProfileConstructionViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        //do stuff from popover
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}

extension SocialProfileConstructionViewController: AddNewServiceProfileDelegate {
    
    func addNewServiceViewControllerDidCancel(_ controller: AddNewServiceViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addNewServiceViewControllerDidSave(_ controller: AddNewServiceViewController, withService service: SocialService?) {
        controller.dismiss(animated: true, completion: nil)
        if let _ = service {
            enabledServices.append(service!)
            lastTappedCell?.socialService = service
        }
        lastTappedCell?.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }
    
    
}

// MARK: - Segue Control
extension SocialProfileConstructionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNetworkSegue" {
            let controller = segue.destination as! AddNewServiceViewController
            controller.popoverPresentationController!.delegate = self
            controller.delegate = self
            let sender = sender as! NetworkCollectionCell
            controller.socialServiceType = sender.socialServiceType
            controller.socialService = sender.socialService
        } else if segue.identifier == "ProfileConstructionCompletedSegue" {
            let tabBarController = segue.destination as! UITabBarController
            let controller = tabBarController.viewControllers?.first as! SocialProfilesViewController
            controller.databaseRef = self.databaseRef
            controller.activeUser = self.activeUser
        }
    }
}
