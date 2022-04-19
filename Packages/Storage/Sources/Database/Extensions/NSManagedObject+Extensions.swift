//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation
import CoreData
extension BaseEntity {
    
    public static func fetchFirst(attributeName: String,
                           attributeValue: Any,
                           context: NSManagedObjectContext) -> Self? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: Self.self))
        
        if let attributeValue = attributeValue as? Bool {
            fetchRequest.predicate = NSPredicate(format: "%K = %d", attributeName, attributeValue)
        } else if let attributeValue = attributeValue as? Int {
            fetchRequest.predicate = NSPredicate(format: "%K = %i", attributeName, attributeValue)
        } else if let attributeValue =  attributeValue as? CVarArg {
            fetchRequest.predicate = NSPredicate(format: "%K = %@", attributeName, attributeValue)
        }
        
        let results = try? context.fetch(fetchRequest)
        return results?.first as? Self
    }
    
    public static func fetchAll<T: BaseEntity>(context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        do {
            let results = try context.fetch(fetchRequest)
            return results as? [T] ?? []
        } catch {
            print("Fetching error: \(error)")
            return []
        }
    }
    
    public static func fetchAll<T: BaseEntity>(attributeName: String,
                                        attributeValue: Any,
                                        context: NSManagedObjectContext) -> [T] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        if let attributeValue = attributeValue as? Bool {
            fetchRequest.predicate = NSPredicate(format: "%K = %d", attributeName, attributeValue)
        } else if let attributeValue = attributeValue as? Int {
            fetchRequest.predicate = NSPredicate(format: "%K = %i", attributeName, attributeValue)
        } else if let attributeValue =  attributeValue as? CVarArg {
            fetchRequest.predicate = NSPredicate(format: "%K = %@", attributeName, attributeValue)
        }
        
        do {
            let results = try context.fetch(fetchRequest)
            return results as? [T] ?? []
        } catch {
            print("Fetching error: \(error)")
            return []
        }

    }
    
    // MARK: Private
    
    private static func allSortDescriptors(from query: String?,
                                           ascending: Bool) -> [NSSortDescriptor] {
        
        guard let values = query?.components(separatedBy: ",") else { return [] }
        
        return values.map { NSSortDescriptor(key: $0, ascending: ascending) }
    }
}
