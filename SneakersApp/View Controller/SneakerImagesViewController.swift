//
//  SneakerImagesViewController.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-29.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import UIKit

protocol SneakerGalleryDelegate {
    func getSneakerImage(images: [UIImage])
}


class SneakerImagesViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    fileprivate let cellId = "cellId"
    var images = [UIImage]()
    fileprivate let sectionInsets = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    fileprivate let itemsPerRow :CGFloat = 3
    var sneakerImageIndex: Int?
    
    var sneakerImageUrls = [CodableSneakerImage]()

    
    var delegate : SneakerGalleryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib (nibName: "SneakerImageCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
        collectionView.backgroundColor = .white

        setupImageDetailView()
        
        downloadImages()
    }
    
    
    func downloadImages() {
        convertUrlsToImages { (images) in
            print("Are we getting in here")
            self.images = images
            
            print("Download Images \(self.images)")
        }
    }
    
    
    //need to modify this to figure out how they use the ebay animation
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//
//        let cells = collectionView.visibleCells
//        var delayCounter = 0
//
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SneakerImageCell
//        for cell in cells {
//
//            cell.transform = CGAffineTransform(translationX: collectionView.bounds.size.width, y: 0)
//
//            UIView.animate(withDuration: 1.6, delay: 0.08 * Double(delayCounter), options: .curveEaseIn, animations: {
//
//
//                cell.transform = CGAffineTransform.identity
//            }, completion: nil)
//            delayCounter += 1
//
//        }
//
//
//    }

    
    func setupImageDetailView() {
        
        let rect = CGRect(x: 0, y: 0, width: 200, height: 60)
    
        let imageGalleryButton = UIButton(frame: rect)
        
        imageGalleryButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageGalleryButton)
        
        NSLayoutConstraint.activate([
            (imageGalleryButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)),
            (imageGalleryButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20))
            ])
        
        imageGalleryButton.widthAnchor.constraint(equalToConstant: 270).isActive = true
        imageGalleryButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
//        imageGalleryButton.backgroundColor = .blue
        imageGalleryButton.setTitle("View Sneaker Image Gallery", for: .normal)
        imageGalleryButton.setTitleColor(.blue, for: .normal)

        imageGalleryButton.setTitleColor(.purple, for: .focused)
        
        imageGalleryButton.addTarget(self, action: #selector(self.goToImageGallery), for: .touchUpInside)
        
    }
    
    @objc func goToImageGallery() {
        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let pageController = storyboard.instantiateViewController(withIdentifier: "pageController") as? PageController
//        pageController!.imageArray = images
//        pageController!.numPages = images.count
//
        
//        self.navigationController?.pushViewController(pageController!, animated: true)
        
//        let slideShowController = SlideShowController()
//        let slideShowController = SlideShowController(transitionStyle: .scroll, navigationOrientation: .horizontal)
//
//        slideShowController.images = images
        
        var slideShowController = SlideShowController(transitionStyle: .scroll, navigationOrientation: .horizontal)

        slideShowController.images = self.images
        
        
//        slideShowController.updateImages(images: self.images)
        self.navigationController?.pushViewController(slideShowController, animated: true)
        
        

    }
    
    
    
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
//    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        
//
//
//    }
    
    
    func updateData() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {

        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)

    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SneakerImageCell
        
//        let sneakerImage = self.images[indexPath.row]
//        cell.sneakerImage = sneakerImage
//
        
        let codableSneakerImageUrl = self.sneakerImageUrls[indexPath.row]
        
        
 
        print("This is the image url \(codableSneakerImageUrl.image_url)")
        cell.codableSneakerImage = codableSneakerImageUrl
        
        return cell
    }
    
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let sneakerImage = images[indexPath.row]
//        self.sneakerImageIndex = indexPath.row
//        openPhotoPicker()
//    }
//
    

    
    func openPhotoPicker() {
        
        if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
//            self.imageView?.image = image
//            self.sneakerImage = image
            guard let index = sneakerImageIndex else {return}
            
            self.images[index] = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return sneakerImageUrls.count
//        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140 , height: 140)
        
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        let imageUrl = self.sneakerImageUrls[indexPath.row]
        var selectedImage : UIImage = UIImage()
        
        selectedImage = self.images[indexPath.row]

        
        

        print("Did SelectItemAt \(imageUrl.image_url!)")
        
        var newImage = UIImage()
        let slideController = SlideController()
//        convertUrlToImage(url: imageUrl.image_url!) { (image) in
//            print("Image Selected \(image)")
//            newImage = image
//
//
//            slideController.image = newImage
//            slideController.itemIndex = 0
//
//
//
//
//        }
//        self.navigationController?.pushViewController(slideController, animated: false)
        
        let window = UIApplication.shared.keyWindow
        
        let screenSize = UIScreen.main.bounds.size
        
        let imageView = UIImageView(frame: self.view.frame)
        imageView.image = selectedImage
        imageView.frame = self.view.frame
//
        slideController.image = selectedImage
        
        self.present(slideController, animated: true, completion: nil)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        
//        imageView.frame = self.view.frame
//        window?.addSubview(imageView)
//
//        
    
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
    func addSneakerImage(image: UIImage) {
        self.images.append(image)
        
        print("These are the images added \(images)")
        collectionView.reloadData()
        
        
    }
    
    public func getSneakerImageCount() -> Int {
        let count = self.images.count
        return count
    }
    
    
    public func getSneakerImages() {
        
        self.delegate?.getSneakerImage(images: self.images)
    }
    
    func removeAllSneakers() {
        self.images.removeAll()
    }
    
    func convertUrlToImage(url: String, completionHandler: @escaping (UIImage)->()) {
        
        
        guard let url = URL(string: url) else {return}
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, _, _) in
            guard let data = data else {return}
            guard let image = UIImage(data: data) else {return}
            completionHandler(image)
        }).resume()
    
    }
    
    
    func convertUrlsToImages(completionHandler: @escaping ([UIImage])->()) {
        
        var images = [UIImage]()
        
        for sneaker in sneakerImageUrls {
            
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
    
    
    
    

}

