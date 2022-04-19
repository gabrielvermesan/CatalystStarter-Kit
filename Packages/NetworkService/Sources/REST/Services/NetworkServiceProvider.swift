//
//  NetworkServiceProvider.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Foundation
import Combine
import Moya
import CombineMoya

// This class should handle the refresh token part aswell. Functionality to be added
final public class NetworkServiceProvider<Target: ApiConfiguration>  {
    private let provider: MoyaProvider<Target>

    init(provider: MoyaProvider<Target>? = nil) {
        
        self.provider = provider ?? MoyaProvider<Target>()
    }

    func request<D: Decodable>(_ target: Target,
                               callbackQueue: DispatchQueue? = nil,
                               decodableType: D.Type,
                               keyPath: String? = nil,
                               failsOnEmptyData: Bool = false,
                               decoder: JSONDecoder = JSONDecoder(),
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) -> AnyPublisher<D, Error> {
        
        decoder.keyDecodingStrategy = keyDecodingStrategy
        decoder.dateDecodingStrategy = .iso8601

        return provider.requestPublisher(target, callbackQueue: callbackQueue)
                .map(decodableType, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
                .mapError { error in
                    error as Error
                }
                .eraseToAnyPublisher()
        
    }
    
    func request<D: Decodable>(_ target: Target,
                               callbackQueue: DispatchQueue? = nil,
                               decodableType: D.Type,
                               keyPath: String? = nil,
                               failsOnEmptyData: Bool = false,
                               decoder: JSONDecoder = JSONDecoder(),
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .convertFromSnakeCase) async throws -> D {
        
        try await withCheckedThrowingContinuation({ continuation in
            decoder.keyDecodingStrategy = keyDecodingStrategy
            decoder.dateDecodingStrategy = .iso8601

            provider.request(target, callbackQueue: callbackQueue) { result in
                switch result {
                case .success(let response):
                    do {
                        let dto = try response.map(decodableType,
                                                   atKeyPath: keyPath,
                                                   using: decoder,
                                                   failsOnEmptyData: failsOnEmptyData)
                        continuation.resume(returning: dto)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        })
    }
}
