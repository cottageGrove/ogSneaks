//
//  ImageUploadViewController.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-21.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import UIKit
import AWSCognito
import AWSS3
import ImageIO

protocol ImageUploadDelegate {
    func retrieveImages(imageUrls : [String], thumbnailImage : UIImage, thumbnailUrl: String)
    
}

class ImageUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SneakerGalleryDelegate {
    
    //Constraints
    @IBOutlet weak var imageViewWidthcConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sneakerImageSelectedButton: UIButton!
    
    @IBOutlet weak var imageView : UIImageView?
    let bucketName = "sneakers-bucket"
    let baseURL = "https://s3.us-east-2.amazonaws.com/sneakers-bucket/"
    var imageURL = ""
    var imageURLS : [String]?
    
    var imageDelegate  : ImageUploadDelegate?
    var sneakerName : String?
    var imageExtension : String?
    var sneakerImage : UIImage?
    var sneakerImages = [UIImage]()
    var sneakerImagesMO = [SneakerImageMO]()
    
    
    var sneakerImagesViewController : SneakerImagesViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageURLS = [String]()
        self.imageView?.contentMode = .scaleAspectFit
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2,
                                                                identityPoolId:"us-east-2:9e28870b-03cc-45d7-ab3c-e8173d81f59a")
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        sneakerImagesViewController = SneakerImagesViewController(collectionViewLayout: layout)
        
        sneakerImagesViewController?.delegate = self
        
        
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    

    
    
    func uploadFile(with resource: String, type: String) {
        let key = "\(resource).\(type)"
        guard let localImagePath = Bundle.main.path(forResource: resource, ofType: type) else {return}
        let localImageUrl = URL(fileURLWithPath: localImagePath)
        
//        let data = Data(contentsOf: localImageUrl)
        
        guard let request = AWSS3TransferManagerUploadRequest() else {return}
        request.bucket = bucketName
        request.key = key
        request.body = localImageUrl
        request.acl = .publicReadWrite
        
        let transferManager = AWSS3TransferManager.default()
        transferManager.upload(request).continueWith(executor: AWSExecutor.mainThread()) { (task) -> Any? in
            
            if let error = task.error {
                print(error)
            }
            if task.result != nil {
                print("Successfully uploaded \(key)")
                print("This is being returned from aws s3 ", task.result)
                print("URL returned \(task.result?.resourceURL)")
            }
            
            return task
            
        }
        
    }
    
    func removeAllImages() {
        print("removing all images for new core data object")
        self.sneakerImages.removeAll()
        self.sneakerImagesMO.removeAll()
        self.sneakerImagesViewController?.removeAllSneakers()
        
        print("Amount of sneaker images left \(sneakerImages.count)")
        print("Amount of core data sneaker images left \(sneakerImagesMO.count)")
    }
    
//    func sUploadMultipleImages(with key: String) {
//
//        for sneaker in sneakerImages {
//            sUploadFile(with: <#T##String#>)
//        }
//    }
//
    func sUploadFile(with key: String, image: UIImage) {
        
//        let key = "\(resource).\(type)"
//        guard let localImagePath = Bundle.main.path(forResource: resource, ofType: type) else {return}
//        let localImageUrl = URL(fileURLWithPath: localImagePath)
        
//        guard let data =  try? Data(contentsOf:) else {return}
        
        
//        guard let data = self.imageView?.image?.jpegData(compressionQuality: 0.1) else {return}
        
        guard let data = image.jpegData(compressionQuality: 0.2) else {return}
        
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityUploadExpression()
        
        
        transferUtility.uploadData(data, bucket: bucketName, key: key, contentType: "image/png", expression: expression) { (task, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            
            
            if let result = task.response {
                print("URL returned is \(result.url?.host)")
                
                print(result.url)
                
//                print("Host URL \(result.url?.host)")
                
                var header = "https://"
                
                guard let host = result.url?.host else {return}
                var hostUrl = "\(header)\(host)"
                let imageUrl = "\(hostUrl)/\(key)"
                print("Image URL \(imageUrl)")
            
            }
        }
        
        
        
    }
    
    func downloadFile(with resource: String, type: String) {
        
        let key = "\(resource).\(type)"
        guard let localImagePath = Bundle.main.path(forResource: resource, ofType: type) else {return}
        let localImageUrl = URL(fileURLWithPath: localImagePath)
        
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()
        
//        transferUtility.downloadData(fromBucket: bucketName, key: key, expression: expression) { (task, url, data, error) in
//
//            if let error = error
//        }
        
        transferUtility.downloadData(fromBucket: bucketName, key: key, expression: expression) { (task, url, data, error) in
            
            if let image = data {
                print("Image returned")
                
                let convertedImage = UIImage(data: image)
                DispatchQueue.main.async {
                    self.imageView?.image = convertedImage
                }

            }
            
            if let result = task.response {
                var header = "https://"
                guard let host = result.url?.host else {return}
                var hostUrl = "\(header)\(host)"
                let imageUrl = "\(hostUrl)/\(key)"
                print("Image URL \(imageUrl)")
            }
//            print("URL: \(task.response?.url?.absoluteString)")
            
            
//            if let urlReturned = url {
//                print("URL Returned is \(urlReturned)" )
//            }
            
        }
        
        
    }
    
    
    //Grabbing local images to store
    func selectImages(with resource: String, type: String) {
        //url of the image
        let key = "\(resource).\(type)"

        
        guard let localImagePath = Bundle.main.path(forResource: resource, ofType: type) else {return}
        
        let localImageURL = URL(fileURLWithPath: localImagePath)
        
        let hostURL = "https://sneakers-bucket.s3.us-east-2.amazonaws.com"
        

        
        let fullURL = "\(hostURL)/\(key)"
        
//        print(fullURL)
//        self.imageURLS?.append(fullURL)
        
        
    }
    
    
//    func uploadMultipleUrls() {
//
//        let uuid = NSUUID().uuidString.lowercased()
//
//        var fullUrl = ""
//
//
//        if let name = sneakerName, !sneakerName!.isEmpty {
//            let imageUrl = "\(name)_\(uuid)"
//            print("image url is: \(imageUrl)")
//
//            guard let image = self.sneakerImage else {
//                print("A sneaker image has not been selected")
//                return
//            }
//
//            guard let type = self.imageExtension else {return}
//
//        }
//
//    }
    
    func uploadImagesToS3(sImage: UIImage) {
        
        let uuid = NSUUID().uuidString.lowercased()
        
        var fullUrl = ""
        
        if let name = sneakerName, !sneakerName!.isEmpty {
            
            //            guard let name = self.sneakerName else {return}
            let imageUrl = "\(name)_\(uuid)"
            print("image url is: \(imageUrl)")
            
            guard let image = self.sneakerImage else {
                print("A sneaker image has not been selected")
                return }
            
            guard let type = self.imageExtension else {return}
            
            var hostURL = "https://sneakers-bucket.s3.us-east-2.amazonaws.com/"
            fullUrl = "\(imageUrl).\(type)"
            
            let filenameEncodedUrl = addPercentCodingToURL(imageUrl: fullUrl)
            
            
            let percentEncodedURL = "\(hostURL)\(filenameEncodedUrl)"
            print(percentEncodedURL)
            
//            selectImages(with: percentEncodedURL, type: type)
            
            //        selectImages(with: "jordan1chi_side_image2", type: "jpg")
            //        selectImages(with: "jordan1chi_image1", type: "jpeg")
            //        selectImages(with: "jordan1chi_side_image4", type: "jpg")
            
            self.imageURLS?.append(percentEncodedURL)
            
            
            sUploadFile(with: fullUrl, image: sImage)
            
        } else {
            print("Please enter the name of the sneaker before uploading images. \n")
            print("Sneaker name cannot be empty either!")
        }
        
    }
    
    
    @IBAction func onUploadTapped() {
        
        //Upload all images in the array to S3
        //URLS of the images stored in the sneakerModel will have to be percent encoded and be placed in the database
        
//        uploadImagesToS3()
        
        uploadAllImages()

    }
    
    func addPercentCodingToURL(imageUrl: String) -> String {
        guard let percentEncodedUrl = imageUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)?.replacingOccurrences(of: " ", with: "%2B") else {return ""}
        
        return percentEncodedUrl
    }

    
    @IBAction func onOpenPhotoGallery() {
        
        self.openPhotoPicker()
        
    }
    
    
    @IBAction func onViewSneakerImages() {
    
        guard let image = sneakerImage else {
            print("Havent selected a picture of the sneaker therefore you goofed")
            return
        }
        
        
        self.sneakerImages.append(image)
        
        guard let imageCount = self.sneakerImagesViewController?.getSneakerImageCount() else {return}
        
        guard let imageViewImage = self.imageView?.image else {return}
        
        guard let sImage = self.sneakerImage else {return print("sneakerImage does not exist")}
        
        if imageCount < 4 {
//            print(self.sneakerImages.count)
            //            sneakerImagesViewController?.images = self.sneakerImages
            
            
            sneakerImagesViewController?.addSneakerImage(image: image)
            
//            for image in images {
//
//                if image == self.sneakerImage {
//                    print("sorry the image has already been selected")
//
//                } else {
//
//
//                }
//            }
            
        }
        

        print("Are we even getting here???")
        
        //This function points to getSneakerImage which converts the image objects into core data objects
//        self.sneakerImagesViewController?.getSneakerImages()
        
        
        
        let newImages = self.sneakerImagesViewController?.images
        
        print("These are the images being returned \(newImages)")
        
        self.navigationController?.pushViewController(self.sneakerImagesViewController!, animated: true)
        
    }
    
    
    func uploadAllImages() {
        
        self.sneakerImagesViewController?.getSneakerImages()
        
        for image in sneakerImages {
            uploadImagesToS3(sImage: image)
        }
        
        print("These are all the imageURLS ", imageURLS)
        
        guard let urls = self.imageURLS else {return}
        
        let thumbnailUrl = urls[0]
        
        self.imageDelegate?.retrieveImages(imageUrls: urls, thumbnailImage: self.sneakerImage!, thumbnailUrl: thumbnailUrl)
        
        
    }
    
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

            self.sneakerImage = image
            self.imageView?.image = image
            
        }
        if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
            print("Print url: ", url)
            print("extension: ", url.pathExtension)
            self.imageExtension = url.pathExtension
        
        }

        picker.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onBulkTapped() {
        
    }
    
    func getSneakerImage(images: [UIImage]){
        
        
        print("These are the images returned from getSneakerImage ", images)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        
        guard let imageEntity = NSEntityDescription.entity(forEntityName: "SneakerImage", in: managedObjectContext) else {return}
        
        let sneakerImageMO = NSManagedObject(entity: imageEntity, insertInto: managedObjectContext)
        guard let sneakerImageContext = sneakerImageMO as? SneakerImageMO else {return}
        

        
        for (index, image) in images.enumerated() {
            
            let sneakerImageMO = NSEntityDescription.insertNewObject(forEntityName: "SneakerImage", into: managedObjectContext) as! SneakerImageMO

            
            
            sneakerImageMO.image = image.pngData()
//            sneakerImageMO.url = "unassigned"
            
            self.sneakerImagesMO.insert(sneakerImageMO, at: index)
            
//            guard let mo = try? managedObjectContext.save() else {return}
        }
        print("CALLING ALL SNEAKERIMAGES")
        
        print(self.sneakerImagesMO)
        
//        self.retrieveSneakerImages()
    }
    
    
    func retrieveSneakerImages() -> [SneakerImageMO] {
        return self.sneakerImagesMO
    }
    
    
    
}
