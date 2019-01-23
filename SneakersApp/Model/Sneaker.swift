//
//  Sneaker.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-19.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CodableSneaker: Codable {
    var name: String?
    var condition: String?
    var size: Int?
    var year: Int?
    var price: Int?
    var id: Int?
    var imageUrls: [String]?
    var image_url: String?
//    var thumbnailImage: UIImage?
}

class Sneaker {
    var name: String?
    var condition: String?
    var size: Int?
    var year: Int?
    var price: Int?
    var imageUrls: [String]?
    var image_url: String?
    var thumbnailImage: UIImage?
}




