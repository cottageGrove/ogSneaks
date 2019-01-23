//
//  PageControl.swift
//  SneakersApp
//
//  Created by Rafae on 2019-01-15.
//  Copyright © 2019 Rafae. All rights reserved.
//

import Foundation
import UIKit

class PageController: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!

//    var pageControl: UIPageControl?
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var contentView: UIView!
    var numPages: Int?
    var pages = [UIView?]()
    
    var imageArray = [UIImage?]()
    var transitioning = false
    
    var imageView = UIImageView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let numPages = self.numPages else {return}

        
        pages = [UIView?](repeating: nil, count: numPages)
        pageControl?.numberOfPages = numPages
        pageControl?.currentPage = 0
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupInitialPages()
        
    }
    
    func setupInitialPages() {
//
        
        adjustScrollView()
//        loadPages(0)
//        loadPages(1)
        
        for (index, page) in pages.enumerated() {
            loadPages(index)
        }
        
    }
    
    fileprivate func adjustScrollView() {
        
        guard let numPages = numPages else {return}
        
        scrollView?.contentSize = CGSize(width: scrollView!.frame.width * CGFloat(numPages), height: scrollView!.frame.height -
            view.safeAreaInsets.top)
        
    }
    
    fileprivate func loadPages(_ page: Int) {
        
        //check to see whether page is in the range of the page array
        
        guard page < numPages! else {return}
        
//        if pages[page] == nil {
            if let image = imageArray[page] {
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                
                
                //Canvas view holds the image
                var frame = scrollView.frame
                frame.origin.x = frame.width * CGFloat(page)
                frame.origin.y = -view.safeAreaInsets.top
                frame.size.height += view.safeAreaInsets.top
                let canvasView = UIView(frame: frame)
                scrollView?.addSubview(canvasView)
                
                imageView.translatesAutoresizingMaskIntoConstraints = false
                canvasView.addSubview(imageView)
            
                
                
                NSLayoutConstraint.activate([
                    (imageView.leadingAnchor.constraint(equalTo: canvasView.leadingAnchor)),
                    (imageView.trailingAnchor.constraint(equalTo: canvasView.trailingAnchor)),
                    (imageView.topAnchor.constraint(equalTo: canvasView.topAnchor)),
                    (imageView.bottomAnchor.constraint(equalTo: canvasView.bottomAnchor))
                    ])
                
                
                pages[page] = canvasView
//            }
            
        }
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {

        let currentImageIndex = self.pageControl.currentPage
        let canvasView = pages[currentImageIndex]

        return canvasView
    }

    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        removeAnyImages()
        
        coordinator.animate(alongsideTransition: nil) { _ in
            self.adjustScrollView()
            self.pages = [UIView?](repeating: nil, count: self.numPages!)
            self.transitioning = true
            
            self.goToPage(page: self.pageControl.currentPage, animated: false)
            self.transitioning = false

        }
        
        super.viewWillTransition(to: size , with: coordinator)
    }
    
    func removeAnyImages() {
        for page in pages where page != nil {
            page?.removeFromSuperview()
        }
    }
    
    func loadCurrentPages(page: Int) {
        let endPage = page + 1
        
        guard let numOfPages = numPages else {return}
        guard (page > 0 && endPage < numOfPages) else {return}
        
        pages = [UIView?](repeating: nil, count: numOfPages)
        loadPages(Int(page) - 1)
        loadPages(Int(page))
        loadPages(Int(page) + 1)
        
        removeAnyImages()
    }
    
    func goToPage(page: Int, animated: Bool) {
        
        loadCurrentPages(page: page)
        var bounds = scrollView.bounds
        bounds.origin.x = bounds.width * CGFloat(page)
        bounds.origin.y = 0
        scrollView.scrollRectToVisible(bounds, animated: animated)

    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Switch the indicator when more than 50% of the previous/next page is visible.
        let pageWidth = scrollView.frame.width
        let page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        pageControl.currentPage = Int(page)
        
        loadCurrentPages(page: pageControl.currentPage)
    }
    
    @IBAction func goToPage(_ sender: UIPageControl) {
        self.goToPage(page: sender.currentPage, animated: true)
    }
    
    
}
