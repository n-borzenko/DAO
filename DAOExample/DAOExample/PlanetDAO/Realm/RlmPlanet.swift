//
//  RlmPlanet.swift
//  DAOExample
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import RealmSwift

class RlmPlanet: Object {
    dynamic var id: Int = 0
    dynamic var name: String = ""

    override static func primaryKey() -> String? {
        return "id"
    }
}
