//
//  ListedSneakerCell.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-25.
//  Copyright © 2018 Rafae. All rights reserved.
//

import UIKit
import SDWebImage

class ListedSneakerCell: UITableViewCell {

    @IBOutlet weak var sneakerModelLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    
    @IBOutlet weak var sneakerImageThumbnail: UIImageView!
    
    
    var sneakerModel: CodableSneaker! {
        didSet {
            sneakerModelLabel.text = sneakerModel.name
            conditionLabel.text = sneakerModel.condition

            guard let price  = sneakerModel.price else {return}
            guard let year = sneakerModel.year else {return}
            guard let size = sneakerModel.size else {return}

            priceLabel.text = String(price)
            yearLabel.text = String(year)
            sizeLabel.text = String(size)
            
            guard let thumbnailURL = sneakerModel.image_url else {return}
            
            guard let url = URL(string: thumbnailURL) else {return}
            
            
            
            self.sneakerImageThumbnail.sd_setImage(with: url, completed: nil)
            self.sneakerImageThumbnail.contentMode = .scaleAspectFit
            
            
//            URLSession.shared.dataTask(with: url) { (data, _, _) in
//
//                guard let data = data else {return}
//
//                DispatchQueue.main.async {
//
//                    self.sneakerImageThumbnail.image = UIImage(data: data)
//                    self.sneakerImageThumbnail.contentMode = .scaleAspectFit
//                }
//
//            }.resume()
            
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
