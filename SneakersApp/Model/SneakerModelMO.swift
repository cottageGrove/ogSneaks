//
//  SneakerModelMO.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-24.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import CoreData

class SneakerModelMO : NSManagedObject {
    @NSManaged var name: String?
    @NSManaged var condition: String?
    @NSManaged var size: Int16
    @NSManaged var year: Int16
    @NSManaged var price: Int16
    @NSManaged var thumbnailImage: Data?
    @NSManaged public var sneakerImages: NSSet?
    
    @objc(addSneakerImagesObject:)
    @NSManaged public func addToSneakerImages(_ value: SneakerImageMO)
    
    @objc(removeSneakerImagesObject:)
    @NSManaged public func removeFromSneakerImages(_ value: SneakerImageMO)
    
    @objc(addSneakerImages:)
    @NSManaged public func addToSneakerImages(_ values: NSSet)
    
    @objc(removeSneakerImages:)
    @NSManaged public func removeFromSneakerImages(_ values: NSSet)
    
}

