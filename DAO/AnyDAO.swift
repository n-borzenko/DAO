//
//  AnyDAO.swift
//  DAO
//
//  Created by n-borzenko on 17.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation

public class AnyDAO<Entity> {
    private let persistEntity: (Entity) -> Bool
    private let persistEntities: ([Entity]) -> Bool

    private let readEntity: (Int) -> Entity?
    private let readEntities: (NSPredicate?) -> [Entity]

    private let eraseEntity: (Int) -> Bool
    private let eraseEntities: () -> Bool

    // MARK: - Initialization

    public init<SomeDAO: DAO>(dao: SomeDAO) where SomeDAO.Entity == Entity {
        persistEntity = dao.persist
        persistEntities = dao.persist
        readEntity = dao.read(id:)
        readEntities = dao.read(predicate:)
        eraseEntity = dao.erase(id:)
        eraseEntities = dao.erase
    }

    // MARK: - Public methods

    /// Сохранение модели
    ///
    /// - Parameter entity: модель
    /// - Returns: успех операции
    @discardableResult public func persist(_ entity: Entity) -> Bool {
        return persistEntity(entity)
    }

    /// Сохранение моделей
    ///
    /// - Parameter entities: массив моделей
    /// - Returns: успех операции
    @discardableResult public func persist(_ entities: [Entity]) -> Bool {
        return persistEntities(entities)
    }

    /// Чтение модели
    ///
    /// - Parameter id: идентификатор модели
    /// - Returns: модель
    public func read(id: Int) -> Entity? {
        return readEntity(id)
    }

    /// Чтение всех моделей
    ///
    /// - Parameter predicate: параметры фильтрации
    /// - Returns: массив моделей
    public func read(predicate: NSPredicate? = nil) -> [Entity] {
        return readEntities(predicate)
    }

    /// Удаление модели
    ///
    /// - Parameter id: идентификатор модели
    /// - Returns: успех операции
    @discardableResult public func erase(id: Int) -> Bool {
        return eraseEntity(id)
    }

    /// Удаление всех моделей
    ///
    /// - Returns: успех операции
    @discardableResult public func erase() -> Bool {
        return eraseEntities()
    }
}
