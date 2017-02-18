//
//  DAOProvider.swift
//  DAOExample
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import DAO
import CoreData
import RealmSwift

enum DataBaseType: Int {
    case realm = 0
    case coreData = 1
}

class PlanetDAOProvider {
    private let dao: [AnyDAO<Planet>]
    
    init() {
        let semaphore = DispatchSemaphore(value: 0)
        let container = NSPersistentContainer(name: "DAOExample")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                print(error)
            }
            semaphore.signal()
        })
        semaphore.wait()
        
        dao = [
            AnyDAO(dao: RealmDAO(translator: RlmPlanetTranslator())),
            AnyDAO(dao: CoreDataDAO(translator: CDPlanetTranslator(), container: container))
        ]
    }
    
    subscript(type: DataBaseType) -> AnyDAO<Planet> {
        get {
            return dao[type.rawValue]
        }
    }
}
