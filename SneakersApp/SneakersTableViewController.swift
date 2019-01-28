//
//  SneakersTableViewController.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-20.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class SneakersTableViewController: UITableViewController{
    
//    var sneakers = [Sneaker]()
    
    
    fileprivate let cellId = "cellId"
    var fSneakers: [NSManagedObject] = []
    var sneakerImagesViewController: SneakerImagesViewController?
    var coreDataImagesViewController : CoreDataImagesViewController?


    
//    var sneakers : [Sneaker]! {
//        didSet{
//            updateSneakerTable()
//        }
//    }
    
    var sneakerContextObjects : [SneakerModelMO]! {
        didSet{
            updateSneakerTable()
        }
    }
    
    func updateSneakerTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupTableView()
        setupSneakerImagesViewController()

        

    }
    
    func setupTableView() {
        let nib = UINib (nibName: "SneakerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    func setupSneakerImagesViewController() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        coreDataImagesViewController = CoreDataImagesViewController(collectionViewLayout: layout)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return sneak.count
        return sneakerContextObjects.count
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let sneakerSelected = sneakerContextObjects[indexPath.row]
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, sourceView, completionHandler) in
            print("index path of delete: \(indexPath)")

            completionHandler(true)
            
            managedObjectContext.delete(sneakerSelected)
            
            self.sneakerContextObjects.remove(at: indexPath.row)
            self.tableView.reloadData()


            
        }
        
        let swipeActionConfig = UISwipeActionsConfiguration(actions: [delete])
        swipeActionConfig.performsFirstActionWithFullSwipe = false
        do {
            try managedObjectContext.save()

        } catch {
            fatalError()
        }
        
        return swipeActionConfig
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sneaker = sneakerContextObjects[indexPath.row]
        processImages(sneaker: sneaker)
        
        self.coreDataImagesViewController?.updateData()
        
        self.navigationController?.pushViewController(self.coreDataImagesViewController!, animated: true)
        
    }
    
    func processImages(sneaker: SneakerModelMO) {
        guard let sneakerImages = sneaker.sneakerImages else {return}
        
        var sneakerImagesArray = [UIImage]()
        
        for image in sneakerImages {
            let sneakerImage = image as! SneakerImageMO
            
            guard let dataImage = sneakerImage.image  else {return}
            guard let newImage = UIImage(data: dataImage) else {return}
            
            sneakerImagesArray.append(newImage)
            
        }
        
        self.coreDataImagesViewController?.images = sneakerImagesArray
        self.coreDataImagesViewController?.updateData()


        
        
        
    }
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SneakerCell
//
//        let sneaker = sneakers[indexPath.row]
//
//        cell.sneaker = sneaker
//        return cell
    
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SneakerCell
        
        
        let savedSneaker = sneakerContextObjects[indexPath.row]
        
        let sneaker = Sneaker()
        
        sneaker.name = savedSneaker.name
        sneaker.price = Int(savedSneaker.price)
        sneaker.year = Int(savedSneaker.year)
        sneaker.condition = savedSneaker.condition
        sneaker.size = Int(savedSneaker.size)
        
        
//        cell.sneaker = sneaker
        cell.sneakerModelMo = savedSneaker
    
        return cell
    
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    
}
