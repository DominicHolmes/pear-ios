//
//  ProfileConstructionViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class SocialProfileConstructionViewController: PearViewController {
    
    var allServices = SocialServiceType.allValues
    var enabledServices = [SocialService]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    var socialProfile: SocialProfile! {
        didSet {
            dump(socialProfile)
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
        //cell?.toggleChecked()
        performSegue(withIdentifier: "addNetworkSegue", sender: cell)
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
        if let _ = service { enabledServices.append(service!) }
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
        }
    }
}
