//
//  SneakersViewController.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-20.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import UIKit
import CoreData


class SneakersViewController: UIViewController, SneakerEntryDelegate, ImageUploadDelegate{

    

    var sneaker: Sneaker?
    var sneakerCollection : [Sneaker]?
    var sneakerEntryView : SneakerEntryView?
    var imageUploadViewController : ImageUploadViewController?
    
    var sneakerImages : [SneakerImageMO]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let window = UIApplication.shared.keyWindow
        
        let entryView = Bundle.main.loadNibNamed("SneakerEntryView", owner: self, options: nil)?.first as! SneakerEntryView
        
        self.sneakerEntryView = entryView
        
//        let imageUploadVC = storyboard?.instantiateViewController(withIdentifier: "imageUploadViewController") as! ImageUploadViewController
        

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let imageUploadVC = storyboard.instantiateViewController(withIdentifier: "imageUploadViewController") as? ImageUploadViewController
        self.imageUploadViewController = imageUploadVC
        
        //initialize variables
        self.sneaker = Sneaker()
        self.sneakerCollection = [Sneaker]()
        
        guard let sneaker = self.sneaker else {return}
        self.sneakerEntryView?.sneaker = sneaker
        
        self.sneakerEntryView?.frame = self.view.frame
//        window?.addSubview(sneakeryEntryView)
        self.view.addSubview(sneakerEntryView!)
        
        self.sneakerEntryView?.delegate = self
        self.imageUploadViewController?.imageDelegate = self
        
        NetworkLayer.shared.searchSneakers(searchText: "Asics") { (sneakers) in
            print("returning sneakers")
            print(sneakers)
        }
        
    }
    
    func addtoCollection(sneakerToAdd: Sneaker) {
        self.sneakerCollection?.append(sneakerToAdd)

        guard let sneakers = self.sneakerCollection else {return}
        
        
        var totalValueOfSneakers : Int
        totalValueOfSneakers = 0
        
        for sneaker in sneakers {
            //print sneakers
            print("Sneaker name: \(sneaker.name)")
            
            guard let price = sneaker.price else {return}
            totalValueOfSneakers += price
        }
        print("total value of sneakers: \(totalValueOfSneakers)")
        
        
        
    }
    
    func onSneakerUpload(sneaker: Sneaker) {
        
        var newSneaker = Sneaker()
        newSneaker.name = sneaker.name
        newSneaker.condition = sneaker.condition
        newSneaker.size = sneaker.size
        newSneaker.price = sneaker.price
        newSneaker.year = sneaker.year
        newSneaker.thumbnailImage = self.sneaker?.thumbnailImage
        newSneaker.image_url = self.sneaker?.image_url
        
//        guard let momUrl = Bundle.main.url(forResource: "SneakerModel", withExtension: "momd", subdirectory: nil, localization: nil) else {
//            fatalError("Error returning sneaker model" )
//        }
//
//        guard let managedObjectModel = NSManagedObjectModel(contentsOf: momUrl) else {return}
//
//        let psc = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
//
//        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        
//        managedObjectContext.persistentStoreCoordinator = psc
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: "SneakerModel", in: managedObjectContext) else {return}
        guard let imageEntity = NSEntityDescription.entity(forEntityName: "SneakerImage", in: managedObjectContext) else {return}
        
        let sneakerMO = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        let sneakerImage = NSManagedObject(entity: imageEntity, insertInto: managedObjectContext)
        
        guard let sneakerObjContext = sneakerMO as? SneakerModelMO else {return}
        guard let sneakerImageContext = sneakerImage as? SneakerImageMO else {return}
        

//        let sneakerMO = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        
        guard let size = newSneaker.size else {return}
        guard let price = newSneaker.price else {return}
        guard let year = newSneaker.year else {return}
        let sizeInt16 = Int16(size)
        let priceInt16 = Int16(price)
        let yearInt16 = Int16(year)
        
        let imageData = self.sneaker?.thumbnailImage?.pngData()
        
//        sneakerObjContext.setValue(newSneaker.name, forKey: "name")
//        sneakerObjContext.setValue(newSneaker.condition, forKey: "condition")
//        sneakerObjContext.setValue(sizeInt16, forKey: "size")
//        sneakerObjContext.setValue(priceInt16, forKey: "price")
//        sneakerObjContext.setValue(yearInt16, forKey: "year")
//        sneakerObjContext.setValue(imageData, forKey: "thumbnailImage")
        
        sneakerObjContext.name = newSneaker.name
        sneakerObjContext.condition = newSneaker.condition
        sneakerObjContext.size = sizeInt16
        sneakerObjContext.price = priceInt16
        sneakerObjContext.year = yearInt16
        sneakerObjContext.thumbnailImage = imageData
        
        
        //CURRENTLY NOT WORKING NEED TO FIGURE THIS OUT
        
        guard let sneakerImagesMO = self.imageUploadViewController?.retrieveSneakerImages() else {return}
        

        print(sneakerImagesMO)

        for sneakerImage in sneakerImagesMO {
            sneakerObjContext.addToSneakerImages(sneakerImage)
            sneakerImage.sneakerModel = sneakerObjContext
        }

        print(sneakerObjContext.sneakerImages)
        
        print("Sneaker Object Context \(sneakerObjContext.size)")
        print("Image URLS \(newSneaker.imageUrls)")
//        NSEntityDescription.insertNewObject(forEntityName: "SneakerModel", into: managedObjectContext)
//        NSEntityDescription.insertNewObject(forEntityName: "SneakerImage", into: managedObjectContext)
        
        
        guard let mo = try? managedObjectContext.save() else {return}


        guard let name = self.sneaker?.name else {return }
        guard let urls = self.sneaker?.imageUrls else {return}
        newSneaker.imageUrls = urls
//        guard let imageURL = self.sneaker?.imageURL else {return}
        
        
        //have to create a new object otherwise its being duplicated every time
        
        addtoCollection(sneakerToAdd: newSneaker)
        NetworkLayer.shared.postSneaker(sneaker: newSneaker)

        
        //Need to clean this up
//        guard var oldImages = self.imageUploadViewController?.sneakerImagesViewController?.images else {return}
        
        self.imageUploadViewController?.removeAllImages()
        
        
        
    }
    
    func onSneakerNameBeginEditing(sneakerName: String) {
        
        self.sneaker?.name = sneakerName

    }
    
    func onSelectImageScreen() {
        

        self.imageUploadViewController?.sneakerName = self.sneaker?.name
        navigationController?.pushViewController(self.imageUploadViewController!, animated: true)
    }
    
    func retrieveImages(imageUrls: [String]) {
//        for url in imageUrls {
//            print("Image URL : ", url)
//        }
        
//        print(imageUrls)

    }
    
    func retrieveImages(imageUrls: [String], thumbnailImage: UIImage, thumbnailUrl: String) {
        print("Images have been retrieved")
        self.sneaker?.imageUrls = imageUrls
        

        self.sneaker?.image_url = thumbnailUrl
        self.sneaker?.thumbnailImage = thumbnailImage
    }

}
