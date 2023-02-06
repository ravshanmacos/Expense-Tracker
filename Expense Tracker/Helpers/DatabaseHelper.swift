//
//  DatabaseHelper.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/02/01.
//

import Foundation
import CoreData
import UIKit

struct DatabaseHelper{
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var loading = false
   
    // MARK: - Create

    func create(entityName: String, data: [String: Any]) {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)!
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        for (key, value) in data {
            object.setValue(value, forKey: key)
        }
        saveContext(message: "Could not save")
    }
    
    //MARK: - Change Observer
    
    mutating func setObserver(entityName:String, sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "fullname", ascending: true)]) -> NSFetchedResultsController<NSFetchRequestResult>?{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.sortDescriptors = sortDescriptors
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }

    // MARK: - Read

    func fetchAll(with request: NSFetchRequest<CreditCard> = CreditCard.fetchRequest(), sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "active", ascending: false)], predicate:NSPredicate?) -> [CreditCard] {
        request.sortDescriptors = sortDescriptors
        if let predicate{request.predicate = predicate}
        do {
            let objects = try context.fetch(request)
            saveContext(message: "error saving")
            return objects
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            return []
        }
    }

    // MARK: - Update

    func update(object: NSManagedObject, data: [String: Any]) {
        for (key, value) in data {
            object.setValue(value, forKey: key)
        }
        saveContext(message: "Could not update")
    }

    // MARK: - Delete

    func delete(object: NSManagedObject) {
        context.delete(object)
        saveContext(message: "Could not delete.")
    }
    
    //MARK: - Save Context
    func saveContext(message: String){
        do {
            try context.save()
        } catch let error as NSError {
            print("\(message): \(error), ")
        }
    }
    
    //MARK: - Listen to Changes
    
    func contextChanged(updateUI: ()->Void){
        if context.hasChanges{
            updateUI()
        }
    }
}
