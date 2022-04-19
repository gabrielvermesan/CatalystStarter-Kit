//
//  UserResponse.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Storage

public struct UserResponse {
    public let avatar: String
    public let profile: String?
    public let name: String
    public let userName: String
}

extension UserResponse {
    
    init?(entity: BaseUserEntity?) {
        
        guard let entity = entity, let avatar = entity.avatar else { return nil }

        self.avatar = avatar
        self.profile = entity.profile
        self.name = entity.name ?? ""
        self.userName = entity.userName ?? ""
    }
    
    init?(entity: BaseUserEntity) {
        
        guard let avatar = entity.avatar else { return nil }
        
        self.avatar = avatar
        self.profile = entity.profile
        self.name = entity.name ?? ""
        self.userName = entity.userName ?? ""
    }
}
