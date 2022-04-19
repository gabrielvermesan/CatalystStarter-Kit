//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 14.04.2022.
//

import Foundation
import Repository


public struct TweetImageDetails {
    public let id: String
    public let urlString: String
}

public struct TweetCommentDetails: Identifiable {
    public let id: String
    public let comment: String
    public let sender: UserDetails
}

extension TweetCommentDetails {
    init(response: TweetCommentResponse) {
        self.id = response.id
        self.comment = response.comment
        self.sender = UserDetails(response: response.sender)
    }
}

public struct TweetDetails {
    public let id: String
    public let content: String?
    public let sender: UserDetails
    public let comments: [TweetCommentDetails]
    public let images: [TweetImageDetails]
}

extension TweetDetails: Identifiable {
        
    init(response: TweetResponse) {
        self.content = response.content
        self.id = response.id
        self.sender = UserDetails(response: response.sender)
        self.comments = response.comments.map(TweetCommentDetails.init)
        self.images = response.images.map { TweetImageDetails(id: $0.id, urlString: $0.urlString) }
    }
}
