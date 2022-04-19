//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Combine

public protocol TweetsService {
    func getTweets(userName: String) -> AnyPublisher<[TweetDto], Error>
}

public class TweetsServiceImpl: BaseServiceImpl<TweetRouter>, TweetsService {
    
    public func getTweets(userName: String) -> AnyPublisher<[TweetDto], Error> {
        provider.request(.getTweets(userName), decodableType: LossyDecodableList<TweetDto>.self)
            .map { $0.elements }
            .eraseToAnyPublisher()
    }
}
