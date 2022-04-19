//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Foundation

public enum TweetRouter: ApiConfiguration {
    case getTweets(String)
    
    public var path: String {
        switch self {
         case .getTweets(let name):
            return "user/" + name + "/tweets"
        }
    }
}
