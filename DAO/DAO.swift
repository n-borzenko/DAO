//
//  DAO.swift
//  DAO
//
//  Created by n-borzenko on 15.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation

public protocol DAO {
    associatedtype Entity

    func persist(_ entity: Entity) -> Bool
    func persist(_ entities: [Entity]) -> Bool

    func read(id: Int) -> Entity?
    func read(predicate: NSPredicate?) -> [Entity]

    func erase(id: Int) -> Bool
    func erase() -> Bool
}
