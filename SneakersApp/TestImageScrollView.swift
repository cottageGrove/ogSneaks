//
//  TestImageScrollView.swift
//  SneakersApp
//
//  Created by Rafae on 2019-01-27.
//  Copyright © 2019 Rafae. All rights reserved.
//

import Foundation
import UIKit


class TestImageScrollView: UIScrollView, UIScrollViewDelegate {
    
    var contentView: UIView?
    var imageView: UIImageView?

    
    override func layoutSubviews() {
        
        self.delegate = self
//        addScrollViewConstraints()
//        addImageViewConstraints()
        
        self.maximumZoomScale = 4.0
        self.minimumZoomScale = 1
        
        self.backgroundColor = .purple

    }
    
    
    func addScrollViewConstraints() {
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        contentView = UIView(frame: rect)
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let cView = self.contentView else {return}
        self.addSubview(cView)
        
        
        contentView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView?.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        contentView?.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
    }
    
    func addImageViewConstraints() {
        
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        imageView = UIImageView(frame: rect)
        guard let cView = contentView else {return}
        guard let iView = imageView else {return}
        
        cView.addSubview(iView)
        
        iView.centerXAnchor.constraint(equalTo: cView.centerXAnchor).isActive = true
        iView.centerYAnchor.constraint(equalTo: cView.centerYAnchor).isActive = true
    
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        //        return self.imageView
        return self.contentView
    }
    
    
    func addImage(image: UIImage) {
        
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        imageView = UIImageView(frame: rect)
//
//        let contentRect = CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: image.size.width, height: image.size.height)
//
        contentView = UIView(frame: rect)
        self.addSubview(contentView!)
        self.contentView?.addSubview(imageView!)
//        self.addSubview(imageView!)
        
//        self.imageView!.center = self.contentView!.center
        

//        guard let iView = imageView else {return}
//        iView.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
//        iView.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
//        self.contentSize = self.contentView!.frame.size
        
    
//        self.contentSize = CGSize(width:imageView!.bounds.width, height: imageView!.bounds.height)
        self.contentSize = contentView!.frame.size
        
        self.contentView?.backgroundColor = .purple
        
        self.imageView?.image = image
        
        self.contentView?.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        self.contentView?.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        self.contentView?.widthAnchor.constraint(equalToConstant: image.size.width).isActive = true
        self.contentView?.heightAnchor.constraint(equalToConstant: image.size.height).isActive = true
        
//        let centerPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
//        self.contentView?.center = centerPoint


        
    }

    
//    func scrollViewDidZoom(_ scrollView: UIScrollView) {
//        self.contentView?.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//        self.contentView?.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -44).isActive = true
//        self.contentView?.widthAnchor.constraint(equalToConstant: self.imageView!.image!.size.width).isActive = true
//        self.contentView?.heightAnchor.constraint(equalToConstant: self.imageView!.image!.size.height).isActive = true
//    }
}
