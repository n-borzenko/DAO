//
//  CoreDataDAO.swift
//  DAO
//
//  Created by n-borzenko on 18.02.17.
//  Copyright © 2017 nborzenko. All rights reserved.
//

import Foundation
import CoreData

/// Реализация DAO для Realm
public class CoreDataDAO<T: CoreDataTranslator>: DAO {
    public typealias Entity = T.Entity
    typealias Entry = T.Entry

    private let container: NSPersistentContainer
    private let translator: T

    // MARK: - Initialization

    /// Инициализация DAO для конкректной модели
    ///
    /// - Parameter translator: транслятор для конкретной модели, подкласс RealmTranslator
    public init(translator: T, container: NSPersistentContainer) {
        self.translator = translator
        self.container = container
    }

    // MARK: - Public methods

    /// Сохранение модели
    ///
    /// - Parameter entity: модель
    /// - Returns: успех операции
    public func persist(_ entity: Entity) -> Bool {
        let predicate = NSPredicate(format: "id = %d", entity.id)
        return performPersist([entity], predicate: predicate)
    }

    /// Сохранение моделей
    ///
    /// - Parameter entities: массив моделей
    /// - Returns: успех операции
    public func persist(_ entities: [Entity]) -> Bool {
        let keys = entities.map { $0.id }
        let predicate = NSPredicate(format: "id IN %@", keys)
        return performPersist(entities, predicate: predicate)
    }

    /// Чтение модели
    ///
    /// - Parameter id: идентификатор модели
    /// - Returns: модель
    public func read(id: Int) -> Entity? {
        let entities = performRead(predicate: NSPredicate(format: "id = %d", id))
        if entities.count == 1 {
            return entities[0]
        } else {
            return nil
        }
    }

    /// Чтение всех моделей
    ///
    /// - Parameter predicate: параметры фильтрации
    /// - Returns: массив моделей
    public func read(predicate: NSPredicate? = nil) -> [Entity] {
        return performRead(predicate: predicate)
    }

    /// Удаление модели
    ///
    /// - Parameter id: идентификатор модели
    /// - Returns: успех операции
    public func erase(id: Int) -> Bool {
        return performErase(predicate: NSPredicate(format: "id = %d", id))
    }

    /// Удаление всех моделей
    ///
    /// - Returns: успех операции
    public func erase() -> Bool {
        return performErase()
    }

    // MARK: - Private methods
    
    /// Синхронное выполнение задачи в бэкграунде
    ///
    /// - Parameter task: задача
    /// - Returns: результат выполнения задачи
    private func performSyncTask<R>(_ task: @escaping (NSManagedObjectContext) -> R) -> R {
        var result: R? = nil
        let semaphore = DispatchSemaphore(value: 0)
        container.performBackgroundTask { context in
            result = task(context)
            semaphore.signal()
        }
        semaphore.wait()
        return result!
    }

    /// Сохранение моделей
    ///
    /// - Parameters:
    ///   - entities: массив моделей
    ///   - predicate: параметры фильтрации
    /// - Returns: успех операции
    private func performPersist(_ entities: [Entity], predicate: NSPredicate) -> Bool {
        return performSyncTask { [unowned self] context -> Bool in
            let request = Entry.fetchRequest()
            request.predicate = predicate
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            _ = try? context.execute(deleteRequest)
            do {
                entities.forEach {
                    context.insert(self.translator.toEntry($0, context: context))
                }
                try context.save()
            }
            catch {
                return false
            }
            return true
        }
    }
    
    /// Чтение моделей
    ///
    /// - Parameter predicate: параметры фильтрации
    /// - Returns: массив моделей
    private func performRead(predicate: NSPredicate? = nil) -> [Entity] {
        return performSyncTask { [unowned self] context -> [Entity] in
            let request = Entry.fetchRequest() as! NSFetchRequest<T.Entry>
            if let predicate = predicate {
                request.predicate = predicate
            }
            do {
                let entries = try context.fetch(request)
                return self.translator.toEntities(entries)
            }
            catch {
                return [Entity]()
            }
        }
    }
    
    /// Удаление моделей
    ///
    /// - Parameter predicate: параметры фильтрации
    /// - Returns: успех операции
    private func performErase(predicate: NSPredicate? = nil) -> Bool {
        return performSyncTask { context -> Bool in
            let request = Entry.fetchRequest()
            if let predicate = predicate {
                request.predicate = predicate
            }
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            do {
                try context.execute(deleteRequest)
                try context.save()
                return true
            }
            catch {
                return false
            }
        }
    }
}
