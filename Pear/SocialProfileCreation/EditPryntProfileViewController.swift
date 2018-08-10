//
//  EditPryntProfileViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

/*import UIKit
import FirebaseDatabase

class EditPryntProfileViewController: PryntViewController {
    
    var profileToEdit: PryntProfile?
    
    private var allServices = SocialServiceType.allValues
    private var enabledServices = [Account]()
    
    weak var lastTappedCell: NetworkCollectionCell?
    
    @IBOutlet weak var collectionView: UICollectionView!
    var socialProfile: SocialProfile!
    
    @IBAction func doneButtonTapped() {
        saveAccountChanges()
        //performSegue(withIdentifier: "ProfileConstructionCompletedSegue", sender: nil)
    }
    
    func saveAccountChanges() {
        /*guard let profileToEdit = profileToEdit else { return }
        profileToEdit.accounts = enabledServices
        ProfileNetworkingManager.shared.updateProfile(from: profileToEdit) { (success, updatedProfile) in
            if success, let updatedProfile = updatedProfile {
                user.add(updatedProfile)
                performSegue(withIdentifier: "EditPryntProfileCompletedSegue", sender: nil)
            } else {
                self.displayAlert("Error", "Couldn't save profile. Please try again later.", nil)
            }
        }*/
        
        /*if activeUser != nil && enabledServices.count > 0 {
            
            let usersProfilesRef: DatabaseReference!
            let allProfilesRef: DatabaseReference!
            
            if socialProfile.hasProfileID() {
                usersProfilesRef = databaseRef.child("usersSocialProfiles").child(activeUser!.id).child(socialProfile.getProfileID())
            } else {
                usersProfilesRef = databaseRef.child("usersSocialProfiles").child(activeUser!.id).childByAutoId()
                socialProfile.setProfileID(id: usersProfilesRef.key)
            }
            allProfilesRef = databaseRef.child("allSocialProfiles").child(socialProfile.getProfileID())
            
            socialProfile.setServices(services: enabledServices)
            usersProfilesRef.setValue(socialProfile.getFirebaseEncoding())
            allProfilesRef.setValue(socialProfile.getFirebaseEncoding())
            
            if !activeUser!.profiles.contains(socialProfile) { activeUser!.profiles.append(socialProfile) }
        }*/
    }
}

// MARK: - CollectionView Data Source
extension EditPryntProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allServices.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell", for: indexPath) as! NetworkCollectionCell
        
        let serviceType = allServices[indexPath.row]
        cell.socialServiceType = serviceType
        
        let enabledServicesOfSameType = enabledServices.filter { $0.service == serviceType }
        if !enabledServicesOfSameType.isEmpty {
            //cell.socialService = enabledServicesOfSameType[0]
        }
        
        let cellImageView = cell.viewWithTag(100) as? UIImageView
        cellImageView?.image = UIImage(named: serviceType.photoName)
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension EditPryntProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as? NetworkCollectionCell
        
        if cell != nil && cell!.isChecked {
            cell!.isChecked = false
            if let service = cell!.socialService {
                //enabledServices = enabledServices.filter { $0.socialService != service.socialService &&
                                                           //$0.handle != service.handle}
            }
        } else if cell != nil && !cell!.isChecked {
            self.lastTappedCell = cell
            performSegue(withIdentifier: "addNetworkSegue", sender: cell)
        }
    }
}

// MARK: - Add New Network Popover
extension EditPryntProfileViewController: UIPopoverPresentationControllerDelegate {
    
    func popoverPresentationControllerDidDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController) {
        //do stuff from popover
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .overFullScreen
    }
    
}

extension EditPryntProfileViewController: AddNewServiceProfileDelegate {
    
    func addNewServiceViewControllerDidCancel(_ controller: AddNewServiceViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func addNewServiceViewControllerDidSave(_ controller: AddNewServiceViewController, withService service: SocialService?) {
        controller.dismiss(animated: true, completion: nil)
        if let _ = service {
            //enabledServices.append(service!)
            lastTappedCell?.socialService = service
        }
        lastTappedCell?.setNeedsLayout()
        collectionView.layoutIfNeeded()
    }
    
    
}

// MARK: - Segue Control
extension EditPryntProfileViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNetworkSegue" {
            let controller = segue.destination as! AddNewServiceViewController
            controller.popoverPresentationController!.delegate = self
            controller.delegate = self
            let sender = sender as! NetworkCollectionCell
            controller.socialServiceType = sender.socialServiceType
            controller.socialService = sender.socialService
        } else if segue.identifier == "ProfileConstructionCompletedSegue" {
            let navController = segue.destination as! UINavigationController
            let tabBarController = navController.topViewController as! PryntTabBarController
            tabBarController.user = self.user
        }
    }
}*/
