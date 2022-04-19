//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation
import NetworkService
import Storage
import CoreData

class TweetEntityFactory {
    
    static func createTweets(using dtos: [TweetDto], storage: DatabaseStorage) -> ([TweetEntity], NSManagedObjectContext) {
        
        let context = storage.bgdContext
        var responses: [TweetEntity]?
        context.performAndWait {
            responses = dtos.enumerated().map { result in
                let dto = result.element
                let tweetEntity = TweetEntity(context: context)
                tweetEntity.content = dto.content
                tweetEntity.identifier = String(result.offset)
                tweetEntity.createdAt = Date()
                tweetEntity.updatedAt = Date()
                
                let senderEntity = UserEntityFactory.createOrUpdateUser(type: TweetSenderEntity.self,
                                                                        dto: dto.sender,
                                                                        context: context)
                
                tweetEntity.sender = senderEntity.0

                let comments = dto.comments?.map({ dto in
                    let entity = CommentEntity(context: context)
                    entity.comment = dto.content
                    entity.identifier = UUID().uuidString
                    entity.createdAt = Date()
                    entity.updatedAt = Date()
                    
                    let senderEntity = UserEntityFactory.createOrUpdateUser(type: CommentUserEntity.self,
                                                                            dto: dto.sender,
                                                                            context: context)
                    entity.commenter = senderEntity.0
                    
                    return entity
                }) ?? []
                
                
                let images = dto.images?.map({ dto in
                    let entity = TweetImageEntity(context: context)
                    entity.urlString = dto.url
                    entity.identifier = UUID().uuidString
                    entity.createdAt = Date()
                    entity.updatedAt = Date()
                    
                    return entity
                }) ?? []
                
                tweetEntity.addToComments(NSSet(array: comments))
                tweetEntity.addToImages(NSSet(array: images))
                return tweetEntity
            }
        }

        return (responses ?? [], context)
    }
}
