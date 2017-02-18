//
//  RlmPlanetTranslator.swift
//  DAOExample
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import DAO

class RlmPlanetTranslator: RealmTranslator {
    func toEntry(_ entity: Planet) -> RlmPlanet {
        let planet = RlmPlanet()
        planet.id = entity.id
        planet.name = entity.name
        return planet
    }
    
    func toEntity(_ entry: RlmPlanet) -> Planet {
        return Planet(id: entry.id, name: entry.name)
    }
}
