//
// Created by Anastasia Zolotykh on 26.06.2018.
// Copyright (c) 2018 kotvaska. All rights reserved.
//

import CoreData

class DbClient {

    func save<Model: CoreDataPO, Object: NSManagedObject>(tableName: String, model: Model, completion: @escaping (Error?) -> ()) -> Object? {
        let managedContext = persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: tableName, in: managedContext) else {
            completion(DbError())
            return nil
        }

        let object = Object(entity: entity, insertInto: managedContext)
        if let object = object as? CoreDataMO {
            object.copyValues(from: model)
        }

        save(object: object, managedContext: managedContext, completion: completion)

        return object

    }

    private func save(object: NSManagedObject, managedContext: NSManagedObjectContext, completion: @escaping (Error?) -> ()) {
        do {
            try managedContext.save()
            completion(nil)

        } catch let error as NSError {
            completion(error)

        }
    }

    func update(tableName: String, partner: Partner, predicate: NSPredicate, completion: @escaping (Error?) -> ()) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)
        fetchRequest.predicate = predicate

        do {
            let newObject = try managedContext.fetch(fetchRequest).first as? PartnerEntity
            newObject?.lastModified = partner.lastModified
            try managedContext.save()
            completion(nil)

        } catch let error as NSError {
            completion(error)
        }
    }

    func fetchList(tableName: String, completion: @escaping ([NSManagedObject], Error?) -> ()) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)

        do {
            let objects = try managedContext.fetch(fetchRequest)
            completion(objects, nil)

        } catch let error as NSError {
            completion([], error)

        }
    }

    func clearAllData(tableName: String, completion: @escaping (Error?) -> ()) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)

        do {
            let news = try managedContext.fetch(fetchRequest)
            news.forEach {
                managedContext.delete($0)
            }
            completion(nil)

        } catch let error as NSError {
            completion(error)

        }
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TinkoffPay")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}
