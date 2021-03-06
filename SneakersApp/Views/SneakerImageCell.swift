//
//  SneakerImageCell.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-29.
//  Copyright © 2018 Rafae. All rights reserved.
//

import UIKit
import SDWebImage

class SneakerImageCell: UICollectionViewCell {

    
    @IBOutlet weak var sneakerImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    var sneakerImage: UIImage! {
        didSet {

            sneakerImageView.contentMode = .scaleAspectFit

            
            guard let compressedData = sneakerImage.jpegData(compressionQuality: 0.00) else {return}
            
            sneakerImageView.image = UIImage(data: compressedData)
//            sneakerImageView.layer.cornerRadius = 5.0
//            sneakerImageView.layer.masksToBounds = true
        }
    }
    
    var codableSneakerImage : CodableSneakerImage! {
        
        didSet {
            print("Are we entering the codableImageURL???")
//            self.sneakerImageView.contentMode = .scaleAspectFit
            
            self.sneakerImageView.contentMode = .scaleAspectFill
            
            guard let imageUrl = codableSneakerImage.image_url else {return}
            
            guard let url = URL(string: imageUrl) else {return}
            
            self.sneakerImageView.sd_setImage(with: url, completed: nil)
//            sneakerImageView.layer.cornerRadius = 5.0
//            sneakerImageView.layer.masksToBounds = true
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    

}
