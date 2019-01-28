//
//  SneakerListingsViewController.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-25.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import UIKit



class SneakerListingsViewController : UITableViewController, UISearchBarDelegate {
    
    fileprivate let cellId = "cellId"
    let searchController = UISearchController(searchResultsController: nil)
    var sneakerImages = [CodableSneakerImage]()
    
    var listedSneakers = [CodableSneaker]()
    
    var sneakerImagesViewController : SneakerImagesViewController?

    
//    var listedSneakers = [CodableSneaker]()
    
//    var listedSneakers : [CodableSneaker]! {
    //        didvar{var            updateSneakerTable()
//        }
//    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
//        DispatchQueue.main.async {
//            NetworkLayer.shared.fetchSneakers { (sneakers) in
//                //            for sneaker in self.sneakers {
//                //                print(sneaker)
//                //            }
//
//                self.listedSneakers = sneakers
//
//                for sneaker in sneakers {
//                    print(sneaker)
//                }
//
//            }
//        }

    }
    func updateSneakerTable() {

        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupSearchBar()
        
        setupSneakerImagesViewController()
        
        NetworkLayer.shared.fetchSneakers { (sneakers) in
            self.listedSneakers = sneakers
        }
        
        searchBar(searchController.searchBar, textDidChange: "jordan 1")


    }
    
    func setupSneakerImagesViewController() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        sneakerImagesViewController = SneakerImagesViewController(collectionViewLayout: layout)

    }
    
    func setupSearchBar() {
        self.definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NetworkLayer.shared.searchSneakers(searchText: searchText) { (sneakers) in
            
            DispatchQueue.main.async {
                if let sneaks = sneakers {
                    self.listedSneakers = sneaks
                }
                self.tableView.reloadData()
            }

            
//            self.listedSneakers = sneakers
  
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sneaker = self.listedSneakers[indexPath.row]
        print("Current Sneaker Selected \(sneaker)")
        
        guard let id = sneaker.id else {return}
        
//        NetworkLayer.shared.fetchSneakerImages(sneakerId: id) { (sneakerImages) in
//
//            print("This is whats returned from sneaker Images.... \(sneakerImages)")
//
//            //this is important since sneakerImages is passed into the completionhandler
//            self.sneakerImages = sneakerImages
//
//            self.convertUrlsToImages { (images) in
//                print("Converted urls to uiimages: ", images)
//                //            self.sneakerImagesViewController?.images = images
//
//
//                DispatchQueue.main.async {
//                    self.sneakerImagesViewController?.images = images
//                }
//
//                self.sneakerImagesViewController?.updateData()
//            }
//
//        }
        
        NetworkLayer.shared.fetchSneakerImages(sneakerId: id) { (sneakerImages) in
            
            print("This is whats returned from sneaker images... \(sneakerImages)")
            self.sneakerImages = sneakerImages
            
            DispatchQueue.main.async {
                self.sneakerImagesViewController?.sneakerImageUrls = sneakerImages
                self.sneakerImagesViewController?.updateData()
                self.sneakerImagesViewController?.downloadImages()
            }


        }
        
//        self.navigationController?.pushViewController(self.coreDataImagesViewController!, animated: true)
        self.navigationController?.pushViewController(self.sneakerImagesViewController!, animated: true)
        
                
    
    }
    
    func convertUrlsToImages(completionHandler: @escaping ([UIImage])->()) {
        
        var images = [UIImage]()
        
        for sneaker in sneakerImages {
            
            guard let imageURL = sneaker.image_url else {return print("No sneaker images exist")}
            
            
            guard let url = URL(string: imageURL) else {return print("Could not convert imageURL to url that request data from endpoint")}
            
            
        
            URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
                guard let data = data else {return}
                guard let image = UIImage(data: data) else {return}
                images.append(image)
                
                print("images: ", images)
                completionHandler(images)
                
            }).resume()
        
        }

    }
    
    func setupTableView() {
        
        let nib = UINib(nibName: "ListedSneakerCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: cellId)
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.listedSneakers.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! ListedSneakerCell
       

        let listedSneaker = self.listedSneakers[indexPath.row]
            
        cell.sneakerModel = listedSneaker


        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    
    
    
}
