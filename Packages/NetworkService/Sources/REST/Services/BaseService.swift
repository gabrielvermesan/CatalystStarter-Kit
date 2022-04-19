//
//  BaseService.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Foundation

public protocol BaseService {
    associatedtype Router: ApiConfiguration
    var provider: NetworkServiceProvider<Router> { get }
}

public class BaseServiceImpl<S: ApiConfiguration>: BaseService {
    public let provider: NetworkServiceProvider<S>

    public init() {
        self.provider = NetworkServiceProvider<Router>()
    }

    init(networkServiceProvider: NetworkServiceProvider<S>) {
        self.provider = networkServiceProvider
    }
}
