//
//  RootPageViewController.swift
//  Prynt
//
//  Created by dominic on 7/1/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class RootPageViewController: PryntPageViewController, UIPageViewControllerDataSource {
    
    lazy var viewControllerList : [UIViewController] = {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let activityVC = storyboard.instantiateViewController(withIdentifier: "ActivityNavigationController") as! ActivityNavigationController
        let cameraVC = storyboard.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        let clusterVC = storyboard.instantiateViewController(withIdentifier: "PersonalNavigationController") as! PersonalNavigationController

        activityVC.user = user
        cameraVC.user = user
        cameraVC.delegate = self
        clusterVC.user = user

        return [activityVC, cameraVC, clusterVC]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        setInitialViewController()
    }
    
    func setInitialViewController() {
        if viewControllerList.count > 1, let firstVC = viewControllerList[1] as? ScannerViewController {
            self.setViewControllers([firstVC], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func setActivityViewController() {
        if viewControllerList.count > 0, let vc = viewControllerList[0] as? ActivityNavigationController {
            self.setViewControllers([vc], direction: .reverse, animated: true, completion: nil)
        }
    }
    
    func setPersonalViewController() {
        if viewControllerList.count > 2, let vc = viewControllerList[2] as? PersonalNavigationController {
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let previousIndex = vcIndex - 1
        guard previousIndex >= 0, viewControllerList.count > previousIndex else { return nil }
        
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.index(of: viewController) else { return nil }
        let nextIndex = vcIndex + 1
        guard viewControllerList.count != nextIndex, viewControllerList.count > nextIndex else { return nil }
        
        return viewControllerList[nextIndex]
    }
}

extension RootPageViewController: RootPageControllable {
    func userDidSelectActivity(_ controller: PryntTabViewController) {
        setActivityViewController()
    }
    func userDidSelectPersonal(_ controller: PryntTabViewController) {
        setPersonalViewController()
    }
}
