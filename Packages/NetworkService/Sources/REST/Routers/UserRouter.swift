//
//  UserRouter.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Foundation

public enum UserRouter: ApiConfiguration {
    
    case getUserDetails(String)
    
    public var path: String {
        switch self {
        case .getUserDetails(let name):
            return "user/" + name
        }
    }
}
