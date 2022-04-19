//
//  UserDto.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Foundation

public struct UserDto: Decodable {
    enum CodingKeys: String, CodingKey {
        case username, nick, avatar
        case profile = "profile-image"
    }
    
    public let username: String
    public let nick: String
    public let avatar: String
    public let profile: String?
}
