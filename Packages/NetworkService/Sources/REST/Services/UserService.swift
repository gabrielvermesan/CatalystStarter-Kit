//
//  UserService.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Combine

public protocol UserService {
    func getUserProfile(name: String) -> AnyPublisher<UserDto, Error>
    func getUserProfile(name: String) async throws -> UserDto
}

public class UserServiceImpl: BaseServiceImpl<UserRouter>, UserService {
    
    public func getUserProfile(name: String) -> AnyPublisher<UserDto, Error> {
        provider.request(.getUserDetails(name), decodableType: UserDto.self)
    }
    
    public func getUserProfile(name: String) async throws -> UserDto {
        try await provider.request(.getUserDetails(name), decodableType: UserDto.self)
    }
}
