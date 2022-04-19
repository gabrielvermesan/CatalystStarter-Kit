//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation

public enum Resource<Result> {
    case loading(Result)
    case success(Result)
    case failure(Result?, Error)
    
    public var value: Result? {
        switch self {
        case .loading(let v), .success(let v):
            return v
        case .failure(let v, _):
            return v
        }
    }
    
    public func mapAs<X>(value: X) -> Resource<X> {
        switch self {
        case .loading:
            return .loading(value)
        case .success:
            return .success(value)
        case let .failure(_, err):
            return .failure(value, err)
        }
    }
}

