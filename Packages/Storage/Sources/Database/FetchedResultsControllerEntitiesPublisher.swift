//
//  FetchedResultsControllerEntitiesPublisher.swift
//  
//
//  Created by Gabriel Vermesan on 13.04.2022.
//

import Foundation
import Combine
import CoreData

public struct SortDetails {
    let name: String?
    let ascending: Bool
}

public class FetchedResultsControllerEntitiesPublisher<Entity: BaseEntity>: Publisher {
    public typealias Output = [Entity]
    public typealias Failure = Error
    
    private let managedObjectContext: NSManagedObjectContext
    private let predicate: NSPredicate?
    private let sortedBy: [SortDetails]?
    private let groupedBy: String?

    init(predicate: NSPredicate? = nil,
         sortedBy: [SortDetails]? = nil,
         groupedBy: String? = nil,
         managedObjectContext: NSManagedObjectContext) {
        
        self.managedObjectContext = managedObjectContext
        self.predicate = predicate
        self.sortedBy = sortedBy
        self.groupedBy = groupedBy
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = FetchedResultsControllerEntitiesPublisher.Subscription(subscriber: subscriber,
                                                                                  predicate: predicate,
                                                                                  sortedBy: sortedBy,
                                                                                  groupedBy: groupedBy,
                                                                                  context: managedObjectContext)
        subscriber.receive(subscription: subscription)
    }
}

extension FetchedResultsControllerEntitiesPublisher {
    class Subscription<S>: NSObject, NSFetchedResultsControllerDelegate where S : Subscriber, Failure == S.Failure, Output == S.Input {
       
        private enum State {
          case waitingForDemand
          case observing(NSFetchedResultsController<Entity>, Subscribers.Demand)
          case completed
          case cancelled
        }
        
        private var state: State
        private var subscriber: S
        private let fetchedResultsController: NSFetchedResultsController<Entity>
        private let context: NSManagedObjectContext
        
        init(subscriber: S,
             predicate: NSPredicate?,
             sortedBy: [SortDetails]?,
             groupedBy: String?,
             context: NSManagedObjectContext) {
            
            self.subscriber = subscriber
            self.context = context
            
            
            let fetchRequest = NSFetchRequest<Entity>(entityName: String(describing: Entity.self))
            fetchRequest.predicate = predicate

            let allSortDescriptors = sortedBy?.compactMap { NSSortDescriptor(key: $0.name, ascending: $0.ascending) } ?? []
            fetchRequest.sortDescriptors = allSortDescriptors
            fetchRequest.fetchBatchSize = 20
            
            fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: context,
                                                                  sectionNameKeyPath: groupedBy,
                                                                  cacheName: nil)
            
            state = .waitingForDemand
        }
        
        
        // MARK: NSFetchedResultsControllerDelegate
       
        func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
            guard case .observing = state else { return }
            receiveUpdatedValues()
        }
        
        // MARK: Private
        
        private func receiveUpdatedValues() {
            guard case .observing(let fetchedResultsController, let demand) = state else {  return }

            let additionalDemand: Subscribers.Demand
            let objects = fetchedResultsController.fetchedObjects ?? []
            additionalDemand = subscriber.receive(objects)

            let newDemand = demand + additionalDemand - 1
            if newDemand == .none {
              fetchedResultsController.delegate = nil
              state = .waitingForDemand
            } else {
              state = .observing(fetchedResultsController, newDemand)
            }
          }
        
        private func receiveCompletion(_ completion: Subscribers.Completion<Error>) {
          guard case .observing = state else { return }

          state = .completed
            subscriber.receive(completion: completion)
        }
    }
}

extension FetchedResultsControllerEntitiesPublisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        switch state {
        case .waitingForDemand:
          guard demand > 0 else { return }
          fetchedResultsController.delegate = self
          state = .observing(fetchedResultsController, demand)

          do {
            try fetchedResultsController.performFetch()
            receiveUpdatedValues()
          } catch {
            receiveCompletion(.failure(error))
          }
        case .observing(let fetchedResultsController, let currentDemand):
          state = .observing(fetchedResultsController, currentDemand + demand)
        case .completed: break
        case .cancelled: break
        }
    }
}

extension FetchedResultsControllerEntitiesPublisher.Subscription: Cancellable {
    func cancel() {
        state = .cancelled
    }
}

