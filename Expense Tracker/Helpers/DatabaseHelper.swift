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
    
    mutating func performFetch(with fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>)->[CreditCard]?{
        loading = true
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        loading = false
        if let objects = fetchedResultsController.fetchedObjects{
            let creditCards = objects.map({$0 as! CreditCard})
            return creditCards
        }
        return nil
    }
    
    func getTransactions(with card:CreditCard, sortDescriptors:[NSSortDescriptor] = [NSSortDescriptor(key: "date", ascending: false)])-> [Transaction]?{
        let transactions = (card.transactions?.sortedArray(using: sortDescriptors).map({ $0 as! Transaction}))!
        return transactions
    }
    
    func getCurrentCard(with creditCards: [CreditCard])->CreditCard?{
        guard let card = creditCards.filter({$0.active}).first else {return nil}
        return card
    }
    
    func getIncomes(with transactions:[Transaction])->[Transaction]{
        return transactions.filter {$0.type == "income"}
    }
    
    func getExpenses(with transactions:[Transaction])->[Transaction]{
        return transactions.filter {$0.type == "expense"}
    }
    

    mutating func fetchAll(with request: NSFetchRequest<CreditCard> = CreditCard.fetchRequest(), sortDescriptors: [NSSortDescriptor] = [NSSortDescriptor(key: "active", ascending: false)], predicate:NSPredicate?) -> [CreditCard] {
        loading = true
        request.sortDescriptors = sortDescriptors
        if let predicate{request.predicate = predicate}
        do {
            let objects = try context.fetch(request)
            saveContext(message: "error saving")
            loading = false
            return objects
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            loading = false
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
