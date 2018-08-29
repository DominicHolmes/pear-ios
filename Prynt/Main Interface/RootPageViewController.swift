//
//  RootPageViewController.swift
//  Prynt
//
//  Created by dominic on 7/1/18.
//  Copyright © 2018 Dominic Holmes. All rights reserved.
//

import UIKit

class RootPageViewController: PryntPageViewController, UIPageViewControllerDataSource {
    
    /*lazy var mainStoryboard: UIStoryboard = {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }()
    
    lazy var activityVC : ActivityNavigationController = {
        return mainStoryboard.instantiateViewController(withIdentifier: "ActivityNavigationController") as! ActivityNavigationController
    }()
    
    lazy var cameraVC : ScannerViewController = {
        return mainStoryboard.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
    }()
    
    lazy var clusterVC : PersonalNavigationController = {
        return mainStoryboard.instantiateViewController(withIdentifier: "PersonalNavigationController") as! PersonalNavigationController
    }()
    
    lazy var viewControllerList : [UIViewController] = {
        
        activityVC.user = user
        cameraVC.user = user
        clusterVC.user = user
        
        return [activityVC, cameraVC, clusterVC]
    }()*/
    
    
    lazy var viewControllerList : [UIViewController] = {
        
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        let activityVC = storyboard.instantiateViewController(withIdentifier: "ActivityNavigationController") as! ActivityNavigationController
        let cameraVC = storyboard.instantiateViewController(withIdentifier: "ScannerViewController") as! ScannerViewController
        let clusterVC = storyboard.instantiateViewController(withIdentifier: "PersonalNavigationController") as! PersonalNavigationController

        activityVC.user = user
        cameraVC.user = user
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
