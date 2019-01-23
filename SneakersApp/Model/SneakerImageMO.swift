//
//  SneakerImageMO.swift
//  SneakersApp
//
//  Created by Rafae on 2018-12-30.
//  Copyright © 2018 Rafae. All rights reserved.
//

import Foundation
import CoreData

class SneakerImageMO: NSManagedObject {
    @NSManaged var imageUrl : String?
    @NSManaged var image: Data?
    @NSManaged public var sneakerModel: SneakerModelMO?
}
