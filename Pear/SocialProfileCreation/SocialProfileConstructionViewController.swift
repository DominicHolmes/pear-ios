//
//  ProfileConstructionViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/18/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class SocialProfileConstructionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!

}

// MARK: - CollectionView Data Source
extension SocialProfileConstructionViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell",
                                                      for: indexPath) as! NetworkCollectionCell
        
        let cellImageView = cell.viewWithTag(100) as? UIImageView
        cellImageView?.image = UIImage(named: "facebook-icon")
        
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

// MARK: - Segue Control
extension SocialProfileConstructionViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNetworkSegue" {
            let controller = segue.destination
            controller.popoverPresentationController!.delegate = self
        }
    }
}
