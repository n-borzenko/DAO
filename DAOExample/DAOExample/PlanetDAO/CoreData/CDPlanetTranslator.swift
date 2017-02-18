//
//  CDPlanetTranslator.swift
//  DAOExample
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import DAO
import CoreData

class CDPlanetTranslator: CoreDataTranslator {
    func toEntry(_ entity: Planet, context: NSManagedObjectContext) -> CDPlanet {
        let planet = CDPlanet(entity: CDPlanet.entity(), insertInto: nil)
        planet.id = Int32(entity.id)
        planet.name = entity.name
        return planet
    }
    
    func toEntity(_ entry: CDPlanet) -> Planet {
        return Planet(id: Int(entry.id), name: entry.name!)
    }
}
