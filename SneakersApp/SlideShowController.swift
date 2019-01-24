//
//  SlideShowController.swift
//  SneakersApp
//
//  Created by Rafae on 2019-01-17.
//  Copyright © 2019 Rafae. All rights reserved.
//

import Foundation
import UIKit

class SlideShowController: UIPageViewController, UIPageViewControllerDataSource{
    
    
    var images = [UIImage?]()
    var startIndex = 0
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! SlideController
        
        
        if itemController.itemIndex! > 0 {
            
            let previousController = SlideController()
            previousController.itemIndex = itemController.itemIndex! - 1
            previousController.image = self.images[itemController.itemIndex! - 1]
            return previousController
        }
        
        if itemController.itemIndex! == 0 {
            let lastController = SlideController()
            lastController.itemIndex = self.images.count - 1
            lastController.image = self.images[self.images.count - 1]
            return lastController
        }
        
        return nil
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let itemController = viewController as! SlideController
        if itemController.itemIndex! + 1 < self.images.count {
            let nextController = SlideController()
            nextController.itemIndex = itemController.itemIndex! + 1
            nextController.image = self.images[itemController.itemIndex! + 1]
            return nextController
        }
        
        if itemController.itemIndex! + 1 == self.images.count {
            let firstController = SlideController()
            firstController.itemIndex = 0
            firstController.image  = self.images[0]
            return firstController
        }
    
        return nil
    }
    

    
    override init(transitionStyle style: UIPageViewController.TransitionStyle, navigationOrientation: UIPageViewController.NavigationOrientation, options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: style, navigationOrientation: navigationOrientation, options: options)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataSource = self
        
        
//        let slideController = self.storyboard?.instantiateViewController(withIdentifier: "slideController") as! SlideController
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        
        let slideController = SlideController()
        
        
        slideController.itemIndex = 0
    
        //MIGHT BE CRUCIAL TO KNOW THIS
        //I've been having errors with this!
        slideController.image = self.images[startIndex]
        
        
        setViewControllers([slideController], direction: .forward, animated: false, completion: nil)
    }
    

}


