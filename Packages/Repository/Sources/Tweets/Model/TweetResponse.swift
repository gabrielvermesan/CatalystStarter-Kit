//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 13.04.2022.
//

import Foundation
import Storage

public struct TweetImageResponse {
    public let id: String
    public let urlString: String
}

public struct TweetCommentResponse {
    public let id: String
    public let comment: String
    public let sender: UserResponse
}

public struct TweetResponse {
    public let id: String
    public let content: String?
    public let sender: UserResponse
    public let comments: [TweetCommentResponse]
    public let images: [TweetImageResponse]
}

extension TweetResponse {
    
    init?(entity: TweetEntity) {
        
        guard let senderEntity = entity.sender, let sender = UserResponse(entity: senderEntity) else {
            return nil
        }
        self.content = entity.content 
        self.id = entity.identifier ?? UUID().uuidString
        self.sender = sender
        self.comments = entity.comments?.allObjects.compactMap({ value -> TweetCommentResponse? in
            if let value = value as? CommentEntity, let commenter = value.commenter, let sender = UserResponse(entity: commenter) {
                return TweetCommentResponse(id: UUID().uuidString,
                                            comment: value.comment ?? "",
                                            sender: sender)
            }
            return nil
        }) ?? []
        self.images = entity.images?.allObjects.compactMap({ value -> TweetImageResponse? in
            if let value = value as? TweetImageEntity, let urlString = value.urlString {
                return TweetImageResponse(id:UUID().uuidString, urlString: urlString)
            }
            return nil
        }) ?? []
    }
}
