//
//  SneakerImageCell.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-29.
//  Copyright © 2018 Rafae. All rights reserved.
//

import UIKit




class SneakerImageCell: UICollectionViewCell {

    
    @IBOutlet weak var sneakerImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var sneakerImage: UIImage! {
        didSet {
            
            sneakerImageView.contentMode = .scaleAspectFit
            sneakerImageView.image = sneakerImage
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    

}
