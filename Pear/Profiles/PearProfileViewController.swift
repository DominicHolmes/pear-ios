//
//  ViewProfileViewController.swift
//  Pear
//
//  Created by Dominic Holmes on 2/1/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class PearProfileViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - CollectionView Data Source
extension PearProfileViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NetworkCell", for: indexPath)
        
        let cellImageView = cell.viewWithTag(100) as? UIImageView
        cellImageView?.image = UIImage(named: "facebook-icon")
        
        return cell
    }
}

// MARK: - CollectionView Delegate
extension PearProfileViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let username =  "dominicfholmes" // Your Instagram Username here
        let appURL = NSURL(string: "instagram://user?username=\(username)")!
        let webURL = NSURL(string: "https://instagram.com/\(username)")!
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL as URL) {
            application.open(appURL as URL)
        } else {
            // if Instagram app is not installed, open URL inside Safari
            application.open(webURL as URL)
        }
    }
}
