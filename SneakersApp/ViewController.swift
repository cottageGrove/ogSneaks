//
//  ViewController.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-19.
//  Copyright © 2018 Rafae. All rights reserved.
//

import UIKit
import CoreData
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var sneakerButton : UIButton!
    var sneakersViewController : SneakersViewController?
    var sneakersTableViewController : SneakersTableViewController?
    var sneakerListingTableViewController : SneakerListingsViewController?
    
    
    //added a new line 
    
    var cSneakers = [CodableSneaker]()
//    var imageUploadViewController : ImageUploadViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        self.sneakersViewController = SneakersViewController()
        self.sneakersTableViewController = SneakersTableViewController()
        self.sneakerListingTableViewController = SneakerListingsViewController()
        

        
//        let imageUploadVC = storyboard?.instantiateViewController(withIdentifier: "imageUploadViewController") as! ImageUploadViewController
//
//        self.imageUploadViewController = imageUploadVC
        
    }
    
    @IBAction func onSneakerButtonTap() {
        
        self.navigationController?.pushViewController(self.sneakersViewController!, animated: true)
        
    }
    
    @IBAction func onSneakersTableButtonTap() {
        
        //stupid flippin thing was returning a null i shouldve known
//        guard let sneakerCollection = self.sneakersViewController?.sneakerCollection else {return}
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        let sneakersFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "SneakerModel")
        
        var fetchedSneakers : [Any]?
        
        do {
            print("Fetching sneakers from persistent data store :)")
            fetchedSneakers = try managedObjectContext.fetch(sneakersFetch)
            
            guard let sneakersArray = fetchedSneakers else {return}
            
            
            for sneaker in sneakersArray {
                let sneakerMO = sneaker as? SneakerModelMO
                print(sneakerMO?.name)
                
            }
            
            print(fetchedSneakers)
        } catch {
            fatalError("Failed to fetch sneakers: \(error)")
        }
        
        let savedSneakers = fetchedSneakers as? [SneakerModelMO]
        
        
//        self.sneakersTableViewController?.sneakers =  sneakerCollection
        self.sneakersTableViewController?.sneakerContextObjects = savedSneakers
        self.navigationController?.pushViewController(self.sneakersTableViewController!, animated: true)
        
    }
    
    @IBAction func showPhotoLibrary() {
        PHPhotoLibrary.requestAuthorization { (status) in
            switch status {
            case .authorized:
                print("Good to print")
                let fetchOptions = PHFetchOptions()
                let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
                
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                
            
                
                
            case .denied, .restricted:
                print("notallowed")
            case .notDetermined:
                print("not determined yet")
            }
        }
    }
    
    
    @IBAction func onSneakerListingsButtonTap() {

//        NetworkLayer.shared.fetchSneakers { (sneakers) in
//            //            for sneaker in self.sneakers {
//            //                print(sneaker)
//            //            }
//            
//            self.cSneakers = sneakers
//            print("returning sneakers")
//            
//            
//        }
        
//        self.sneakerListingTableViewController?.listedSneakers = self.cSneakers
        self.navigationController?.pushViewController(self.sneakerListingTableViewController!, animated: true)
        
    }
    

}

