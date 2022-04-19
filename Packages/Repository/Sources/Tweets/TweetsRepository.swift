//
//  TweetsRepository.swift
//  
//
//  Created by Gabriel Vermesan on 14.04.2022.
//

import Storage
import NetworkService
import Combine
import Common

public protocol TweetsRepository {
    func getAllTweets() -> AnyPublisher<Resource<[TweetResponse]>, Never>
}

public class TweetsRepositoryImpl: TweetsRepository {

    private let service: TweetsService
    private let dbStorage: DatabaseStorage
    private let schedulers: Schedulers

    public init(service: TweetsService = TweetsServiceImpl(),
                dbStorage: DatabaseStorage = DatabaseStorageImpl(),
                schedulers: Schedulers) {
        self.service = service
        self.dbStorage = dbStorage
        self.schedulers = schedulers
    }
    
    public func getAllTweets() -> AnyPublisher<Resource<[TweetResponse]>, Never> {
        let networkBoundResource = TweetsNetworkBoundResourceImpl(service: self.service,
                                                                storage: self.dbStorage,
                                                                schedulers: self.schedulers,
                                                                userName: "jsmith")
        
        return networkBoundResource.load()
    }
}
