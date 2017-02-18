//
//  RealmDAO.swift
//  DAO
//
//  Created by n-borzenko on 15.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import RealmSwift

/// Реализация DAO для Realm
public class RealmDAO<T: RealmTranslator>: DAO {
    public typealias Entity = T.Entity
    typealias Entry = T.Entry

    private let translator: T

    // MARK: - Initialization

    /// Инициализация DAO для конкректной модели
    ///
    /// - Parameter translator: транслятор для конкретной модели, подкласс RealmTranslator
    public init(translator: T, realmConfiguration: Realm.Configuration? = nil) {
        self.translator = translator
        if let configuration = realmConfiguration {
            Realm.Configuration.defaultConfiguration = configuration
        }
    }

    // MARK: - Public methods

    /// Сохранение модели
    ///
    /// - Parameter entity: модель
    /// - Returns: успех операции
    public func persist(_ entity: Entity) -> Bool {
        let realm = try! Realm()
        do {
            try realm.write {
                performUpdate(realm: realm, entity: entity)
            }
        } catch {
            return false
        }
        return true
    }

    /// Сохранение моделей
    ///
    /// - Parameter entities: массив моделей
    /// - Returns: успех операции
    public func persist(_ entities: [Entity]) -> Bool {
        let realm = try! Realm()
        do {
            try realm.write {
                entities.forEach { performUpdate(realm: realm, entity: $0) }
            }
        } catch {
            return false
        }
        return true
    }

    /// Чтение модели
    ///
    /// - Parameter id: идентификатор модели
    /// - Returns: модель
    public func read(id: Int) -> Entity? {
        let realm = try! Realm()
        if let entry = realm.object(ofType: Entry.self, forPrimaryKey: id) {
            return translator.toEntity(entry)
        }
        return nil
    }

    /// Чтение всех моделей
    ///
    /// - Parameter predicate: параметры фильтрации
    /// - Returns: массив моделей
    public func read(predicate: NSPredicate? = nil) -> [Entity] {
        let realm = try! Realm()
        var entries = realm.objects(Entry.self)
        if let predicate = predicate {
            entries = entries.filter(predicate)
        }
        return translator.toEntities(Array(entries))
    }

    /// Удаление модели
    ///
    /// - Parameter id: идентификатор модели
    /// - Returns: успех операции
    public func erase(id: Int) -> Bool {
        let realm = try! Realm()
        guard let object = realm.object(ofType: Entry.self, forPrimaryKey: id) else {
            return false
        }
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            return false
        }
        return true
    }

    /// Удаление всех моделей
    ///
    /// - Returns: успех операции
    public func erase() -> Bool {
        let realm = try! Realm()
        let objects = realm.objects(Entry.self)
        do {
            try realm.write {
                realm.delete(objects)
            }
        } catch {
            return false
        }
        return true
    }

    // MARK: - Private methods

    /// Обновление сущности БД
    ///
    /// - Parameter entity: сущность БД
    private func performUpdate(realm: Realm, entity: Entity) {
        if let object = realm.object(ofType: Entry.self, forPrimaryKey: entity.id) {
            realm.delete(object)
        }
        realm.add(translator.toEntry(entity), update: true)
    }
}
