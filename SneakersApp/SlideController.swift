//
//  SlideController.swift
//  SneakersApp
//
//  Created by Rafae on 2019-01-17.
//  Copyright © 2019 Rafae. All rights reserved.
//

import Foundation
import UIKit

class SlideController: UIViewController {
    
    var itemIndex : Int?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scrollView: ImageScrollView = ImageScrollView()
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scrollView.backgroundColor = .white
        
        self.view = scrollView
        
        guard let image = self.image else {return}
        
        scrollView.displayImage(image)
        scrollView.placeImageInCenter()
        
        setupCancelView()
        
    }
    
    func setupCancelView() {
        
        
        let rect = CGRect(x: 0, y: 0, width: 100, height: 100)
        let closeButton = UIButton(frame: rect)
        
        self.view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("X", for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "San Francisco", size: 40)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.text = "X"
        closeButton.backgroundColor = .blue
        closeButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 100).isActive = true
        closeButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 100).isActive = true

        closeButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 100).isActive = true

        
    }
    
    
}
