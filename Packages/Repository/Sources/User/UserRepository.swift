//
//  UserRepository.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Storage
import NetworkService
import Combine
import Common

public protocol UserRepository {
    func getUserProfile() -> AnyPublisher<Resource<UserResponse?>, Never>
}

public class UserRepositoryImpl: UserRepository {

    private let service: UserService
    private let dbStorage: DatabaseStorage
    private let schedulers: Schedulers

    public init(service: UserService = UserServiceImpl(),
                dbStorage: DatabaseStorage = DatabaseStorageImpl(),
                schedulers: Schedulers) {
        self.service = service
        self.dbStorage = dbStorage
        self.schedulers = schedulers
    }
    
    public func getUserProfile() -> AnyPublisher<Resource<UserResponse?>, Never> {
        let networkBoundResource = UserNetworkBoundResourceImpl(service: self.service,
                                                                storage: self.dbStorage,
                                                                schedulers: self.schedulers,
                                                                userName: "jsmith")
        
        return networkBoundResource.load()
    }
}
