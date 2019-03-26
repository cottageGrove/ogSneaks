//
//  LocalSneakerImagesViewController.swift
//  SneakersApp
//
//  Created by Rafae on 2019-01-25.
//  Copyright © 2019 Rafae. All rights reserved.
//

import Foundation
import UIKit

class CoreDataImagesViewController: SneakerImagesViewController {
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SneakerImageCell
        
        let sneakerImage = self.images[indexPath.row]
        cell.sneakerImage = sneakerImage
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
}
