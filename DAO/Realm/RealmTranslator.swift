//
//  RealmTranslator.swift
//  DAO
//
//  Created by n-borzenko on 15.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import RealmSwift

/// Базовый транслятор для RealmDAO
public protocol RealmTranslator {
    associatedtype Entity: BaseEntity
    associatedtype Entry: Object

    /// Конвертация модели в cущность БД
    ///
    /// - Parameter entity: модель
    /// - Returns: сущность БД
    func toEntry(_ entity: Entity) -> Entry

    /// Конвертация сущности БД в модель
    ///
    /// - Parameter entry: сущность БД
    /// - Returns: модель
    func toEntity(_ entry: Entry) -> Entity
}

extension RealmTranslator {
    /// Конвертация моделей в cущности БД
    ///
    /// - Parameter entities: массив моделей
    /// - Returns: массив сущностей БД
    func toEntries(_ entities: [Entity]) -> [Entry] {
        return entities.map { self.toEntry($0) }
    }
    
    /// Конвертация сущностей БД в модели
    ///
    /// - Parameter entries: массив сущностей БД
    /// - Returns: массив моделей
    func toEntities(_ entries: [Entry]) -> [Entity] {
        return entries.map { self.toEntity($0) }
    }
}
