//
//  PersistentContainer.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: AccessGroup.accessGroup)
        storeURL = storeURL?.appendingPathComponent("Catalyst.sqlite")
        return storeURL!
    }

}

public enum ContainerType {
    case production
    case inMemory
}

public protocol PersistentContainer {
    var viewContext: NSManagedObjectContext { get }
    var bgdContext: NSManagedObjectContext { get }
        
    @discardableResult
    func saveContext(context: NSManagedObjectContext) -> Bool
}

final public class PersistentContainerImpl: PersistentContainer {
    
    deinit {
        DarwinNotificationCenter.shared.removeObserver(self, for: .didSaveManagedObjectContextLocally)
    }
    
    public var viewContext: NSManagedObjectContext { container.viewContext }
    public var bgdContext: NSManagedObjectContext {
        let context = container.newBackgroundContext()
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    public static let shared = PersistentContainerImpl()
    
    private let container: NSPersistentContainer
    public init(name: String = "Catalyst", type: ContainerType = .production) {
        
        
        let bundle = Bundle.module
        let modelURL = bundle.url(forResource: "Catalyst", withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        container = NSCustomPersistentContainer(name: name, managedObjectModel: model)
        if type == .inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores { [weak self ] (description, error) in
            print(description)
            self?.container.viewContext.automaticallyMergesChangesFromParent = true
        }
        observeAppExtensionDataChanges()
    }
    
    @discardableResult
    public func saveContext(context: NSManagedObjectContext) -> Bool {
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch let error {
                print("Error saving model: \(error)")
                return false
            }
        }
        return true
    }
    
    private func observeAppExtensionDataChanges() {
        
        DarwinNotificationCenter.shared.addObserver(self, for: .didSaveManagedObjectContextLocally, using: { [weak self] (_) in
            // Since the viewContext is our root context that's directly connected to the persistent store, we need to update our viewContext.
            
            self?.viewContext.perform {
                self?.viewContextDidSaveExternally()
            }
        })
    }
    
    /// Called when a certain managed object context has been saved from an external process. It should also be called on the context's queue.
    private func viewContextDidSaveExternally() {
        // `refreshAllObjects` only refreshes objects from which the cache is invalid. With a staleness intervall of -1 the cache never invalidates.
        // We set the `stalenessInterval` to 0 to make sure that changes in the app extension get processed correctly.
        viewContext.stalenessInterval = 0
        viewContext.refreshAllObjects()
        viewContext.stalenessInterval = -1
    }
}
