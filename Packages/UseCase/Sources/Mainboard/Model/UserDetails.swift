//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 13.04.2022.
//

import Repository

public struct UserDetails {
    public let avatar: String
    public let profile: String?
    public let name: String
    public let userName: String
}

extension UserDetails {
    
    init?(response: UserResponse?) {
        
        guard let response = response else { return nil }

        self.avatar = response.avatar
        self.profile = response.profile
        self.name = response.name
        self.userName = response.userName
    }
    
    init(response: UserResponse) {
        
        self.avatar = response.avatar
        self.profile = response.profile
        self.name = response.name
        self.userName = response.userName
    }
}
