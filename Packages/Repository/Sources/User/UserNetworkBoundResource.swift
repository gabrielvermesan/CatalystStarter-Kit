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

class UserNetworkBoundResourceImpl: NetworkBoundResource {
    
    private let service: UserService
    private let storage: DatabaseStorage
    private let userName: String
    
    let schedulers: Schedulers

    init(service: UserService,
         storage: DatabaseStorage,
         schedulers: Schedulers,
         userName: String) {
        self.service = service
        self.storage = storage
        self.schedulers = schedulers
        self.userName = userName
    }
    
    func getLocalData() -> AnyPublisher<(CurrentUserEntity?, NSManagedObjectContext), Never> {
        storage.getCurrentUser(name: userName)
    }
    
    func getRemoteData() -> AnyPublisher<UserDto, Error> {
        service.getUserProfile(name: userName)
    }
    
    func mapRemoteToLocal(_ remote: UserDto) -> (CurrentUserEntity?, NSManagedObjectContext) {
        UserEntityFactory.createOrUpdateUser(type: CurrentUserEntity.self, dto: remote, context: storage.bgdContext)
    }
    
    func mapLocalToOutput(_ local: (CurrentUserEntity?, NSManagedObjectContext)) -> UserResponse? {
        UserResponse(entity: local.0)
    }
    
    func saveToLocal(_ local: (CurrentUserEntity?, NSManagedObjectContext)) {
        storage.saveContext(local.1)
    }
}
