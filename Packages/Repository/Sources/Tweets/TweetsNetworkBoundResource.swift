//
//  File.swift
//
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation
import NetworkService
import Storage
import Combine
import Common
import CoreData

class TweetsNetworkBoundResourceImpl: NetworkBoundResource {
    
    private let service: TweetsService
    private let storage: DatabaseStorage
    private let userName: String
    
    let schedulers: Schedulers

    init(service: TweetsService,
         storage: DatabaseStorage,
         schedulers: Schedulers,
         userName: String) {
        self.service = service
        self.storage = storage
        self.userName = userName
        self.schedulers = schedulers
    }
    
    func getLocalData() -> AnyPublisher<([TweetEntity], NSManagedObjectContext), Never> {
        storage.getAllTweets()
    }
    
    func getRemoteData() -> AnyPublisher<[TweetDto], Error> {
        service.getTweets(userName: userName)
    }
    
    func mapRemoteToLocal(_ remote: [TweetDto]) -> ([TweetEntity], NSManagedObjectContext) {
        TweetEntityFactory.createTweets(using: remote.filter { $0.isValid }, storage: storage)
    }
    
    func mapLocalToOutput(_ local: ([TweetEntity], NSManagedObjectContext)) -> [TweetResponse] {
        local.0.compactMap(TweetResponse.init)
    }
    
    func saveToLocal(_ local: ([TweetEntity], NSManagedObjectContext)) {
        storage.deleteOldTweets()
        storage.saveContext(local.1)
    }
}
