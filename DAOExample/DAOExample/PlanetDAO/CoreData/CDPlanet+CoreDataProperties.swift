//
//  CDPlanet+CoreDataProperties.swift
//  DAOExample
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import CoreData


extension CDPlanet {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPlanet> {
        return NSFetchRequest<CDPlanet>(entityName: "CDPlanet");
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?

}
