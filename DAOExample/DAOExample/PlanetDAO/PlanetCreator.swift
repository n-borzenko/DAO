//
//  PlanetCreator.swift
//  DAOExample
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation

class PlanetCreator {
    static func createPlanets() -> [Planet] {
        return [
            Planet(id: 0, name: "Mercury"),
            Planet(id: 1, name: "Venus"),
            Planet(id: 2, name: "Earth"),
            Planet(id: 3, name: "Mars"),
            Planet(id: 4, name: "Jupiter"),
            Planet(id: 5, name: "Saturn"),
            Planet(id: 6, name: "Uranus"),
            Planet(id: 7, name: "Neptune")
        ]
    }
    
    static func createPluto() -> Planet {
        return Planet(id: 8, name: "Pluto")
    }
}
