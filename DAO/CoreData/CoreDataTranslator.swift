//
//  CoreDataTranslator.swift
//  DAO
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import CoreData

/// Базовый транслятор для CoreDataDAO
public protocol CoreDataTranslator {
    associatedtype Entity: BaseEntity
    associatedtype Entry: NSManagedObject

    /// Конвертация модели в cущность БД
    ///
    /// - Parameters:
    ///   - entity: модель
    ///   - context: контекст для создания сущности БД
    /// - Returns: сущность БД
    func toEntry(_ entity: Entity, context: NSManagedObjectContext) -> Entry

    /// Конвертация сущности БД в модель
    ///
    /// - Parameter entry: сущность БД
    /// - Returns: модель
    func toEntity(_ entry: Entry) -> Entity
}

extension CoreDataTranslator {
    /// Конвертация моделей в cущности БД
    ///
    /// - Parameters:
    ///   - entities: массив моделей
    ///   - context: контекст для создания сущностей БД
    /// - Returns: массив сущностей БД
    func toEntries(_ entities: [Entity], context: NSManagedObjectContext) -> [Entry] {
        return entities.map { self.toEntry($0, context: context) }
    }

    /// Конвертация сущностей БД в модели
    ///
    /// - Parameter entries: массив сущностей БД
    /// - Returns: массив моделей
    func toEntities(_ entries: [Entry]) -> [Entity] {
        return entries.map { self.toEntity($0) }
    }
}
