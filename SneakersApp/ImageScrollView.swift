//
//  ImageScrollView.swift
//  SneakersApp
//
//  Created by Rafae on 2019-01-17.
//  Copyright © 2019 Rafae. All rights reserved.
//

import Foundation
import UIKit

class ImageScrollView: UIScrollView, UIScrollViewDelegate {
    
    var imageView: UIImageView?
    var contentView: UIView?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let rect = CGRect(x: 0, y: 0, width: 1000, height: 1300)
        self.contentView = UIView(frame: rect)
        
        self.maximumZoomScale = 4.0
        self.minimumZoomScale = 1
        self.delegate = self
        
    }


    override func layoutSubviews() {
        super.layoutSubviews()
        
        // center the zoom view as it becomes smaller than the size of the screen
        let boundsSize: CGSize = self.bounds.size
        var frameToCenter: CGRect = self.imageView!.frame

        // center horizontally
        if frameToCenter.size.width < boundsSize.width {
            frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2

        }
        else {
            frameToCenter.origin.x = 0
        }

        // center vertically
        if (frameToCenter.size.height < boundsSize.height) {
            frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2
        }
        else {
            frameToCenter.origin.y = 0
        }
//
//
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2

        self.imageView!.frame = frameToCenter
        
//        let resizedImage = resizeImage(image: image)
//        self.imageView = UIImageView(image: resizedImage)
        
//        self.contentView?.translatesAutoresizingMaskIntoConstraints = false
        guard let contentView = self.contentView else {return}
        self.addSubview(contentView)
//
////        self.contentView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//
////        self.contentView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        self.contentView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        self.contentView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        self.contentView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//        self.contentView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        guard let imageView = self.imageView else {return}
        self.contentView?.addSubview(self.imageView!)
        

//        self.contentSize = contentView.frame.size
//        self.addSubview(self.imageView!)
        
//        self.imageView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.imageView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        let offsetX: CGFloat = max((self.bounds.size.width - self.contentSize.width) * 0.5, 0.0)
        let offsetY: CGFloat = max((self.bounds.size.height - self.contentSize.height) * 0.5, 0.0)
        

        
        imageView.center = CGPoint(x: self.contentSize.width * 0.5 + offsetX, y: self.contentSize.height * 0.5 + offsetY)
        
    }
    
    func displayImage(_ image: UIImage) {
        
//        imageView?.removeFromSuperview()
        
        let resizedImage = resizeImage(image: image)
        self.imageView = UIImageView(image: resizedImage)
        
//        self.imageView!.contentMode = .scaleAspectFit
//        self.addSubview(self.imageView!)
        
        
        self.configureImageSize(image.size)
        

        
        self.updateConstraints()
    }
    
    func resizeImage(image: UIImage) -> UIImage {
        let size = image.size
        
        print("Size ", image.size)
        
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        let screenWidth = screenSize.width
        
        let widthRatio = screenWidth / size.width
        let heightRatio = screenHeight / size.height
        
        let newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    

        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        
//        if let image =
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()


        
        return newImage
        
    }
    
    func configureImageSize(_ imageSize: CGSize) {
        
        self.contentSize = imageSize
//        self.contentSize = self.contentView!.frame.size
//        self.contentSize = imageSize
        self.zoomScale = self.minimumZoomScale
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
//        return self.imageView
        return self.imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {

        let offsetX: CGFloat = max((scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5, 0.0)
        let offsetY: CGFloat = max((scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5, 0.0)
        
        guard let imageView = self.imageView else {return}
        
        imageView.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)

    }
    
    func placeImageInCenter() {
        let offsetX: CGFloat = max((self.bounds.size.width - self.contentSize.width) * 0.5, 0.0)
        let offsetY: CGFloat = max((self.bounds.size.height - self.contentSize.height) * 0.5, 0.0)
        
        guard let imageView = self.imageView else {return}
        
        imageView.center = CGPoint(x: self.contentSize.width * 0.5 + offsetX, y: self.contentSize.height * 0.5 + offsetY)

    }
}
