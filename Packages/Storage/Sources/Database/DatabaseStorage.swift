//
//  DababaseStorage.swift
//  reminder
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import CoreData
import UIKit
import Combine

public protocol DatabaseStorage {
    var bgdContext: NSManagedObjectContext { get }

    func getCurrentUser(name: String) -> AnyPublisher<(CurrentUserEntity?, NSManagedObjectContext), Never>
    func getAllTweets() -> AnyPublisher<([TweetEntity], NSManagedObjectContext), Never>
    func saveContext(_ context: NSManagedObjectContext)
    func deleteOldTweets()
}

final public class DatabaseStorageImpl: DatabaseStorage {
    
    private let container: PersistentContainer

    public init(container: PersistentContainer = PersistentContainerImpl.shared) {
        self.container = container
    }
    
    public var bgdContext: NSManagedObjectContext { container.bgdContext }

    
    public func getCurrentUser(name: String) -> AnyPublisher<(CurrentUserEntity?, NSManagedObjectContext), Never> {
        FetchedResultsControllerEntitiesPublisher<CurrentUserEntity>(predicate: NSPredicate(format: "%K == %@",#keyPath(CurrentUserEntity.userName),  name),
                                                  managedObjectContext: container.viewContext)
                                .map { ($0.first, self.container.viewContext) }
                                .replaceError(with: (nil, container.viewContext))
                                .eraseToAnyPublisher()
    }
    
    public func getAllTweets() -> AnyPublisher<([TweetEntity], NSManagedObjectContext), Never> {
        FetchedResultsControllerEntitiesPublisher<TweetEntity>(managedObjectContext: container.viewContext)
                                .map { ($0, self.container.viewContext) }
                                .replaceError(with: ([], container.viewContext))
                                .eraseToAnyPublisher()
    }

    public func saveContext(_ context: NSManagedObjectContext) {
        container.saveContext(context: context)
    }
    
    public func deleteOldTweets() {
        let context = container.bgdContext
        
        context.performAndWait {
            let all = TweetEntity.fetchAll(context: context)
            all.forEach { entity in
                context.delete(entity)
            }
            saveContext(context)
        }
    }
}
