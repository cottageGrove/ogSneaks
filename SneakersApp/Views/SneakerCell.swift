//
//  SneakerCell.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-20.
//  Copyright © 2018 Rafae. All rights reserved.
//

import UIKit

class SneakerCell: UITableViewCell {
    
    
    @IBOutlet weak var sneakerModelLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var sneakerImageThumbnail: UIImageView!
    
//    var sneaker: Sneaker! {
//        didSet {
//            sneakerModelLabel.text = sneaker.name
//            conditionLabel.text = sneaker.condition
//            
//            
//            print("In the sneaker cell now... printing the sneaker size here")
//            guard let price = sneaker?.price else {return}
//            guard let year = sneaker?.year else {return}
//            guard let size = sneaker?.size else {return}
//            guard let image = sneaker?.thumbnailImage else {return}
//            priceLabel.text = String(price)
//            yearLabel.text = String(year)
//            sizeLabel.text = String(size)
//            
//            print("Sneaker size \(size)")
//            sneakerImageThumbnail.image = image
//            self.sneakerImageThumbnail.contentMode = .scaleToFill
//        }
//    }
    
    var sneakerModelMo: SneakerModelMO! {
        didSet {
            sneakerModelLabel.text = sneakerModelMo.name
            conditionLabel.text = sneakerModelMo.condition
            
            guard let price = sneakerModelMo?.price else {return}
            guard let year = sneakerModelMo?.year else {return}
            guard let size = sneakerModelMo?.size else {return}


            priceLabel.text = String(price)
            yearLabel.text = String(year)
            sizeLabel.text = String(size)
            
            if let dataImage = sneakerModelMo?.thumbnailImage {
                let image = UIImage(data: dataImage)
                sneakerImageThumbnail.image = image
                self.sneakerImageThumbnail.contentMode = .scaleAspectFit
            }


//            print("Sneaker size \(size)")
//            sneakerImageThumbnail.image = image
//            self.sneakerImageThumbnail.contentMode = .scaleToFill
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
