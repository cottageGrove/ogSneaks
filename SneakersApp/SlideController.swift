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
    }
    
    
}
