//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 12.04.2022.
//

import Foundation
import NetworkService
import CoreData
import Storage

class UserEntityFactory {
    
    static func createOrUpdateUser<N: BaseUserEntity>(type: N.Type,
                                                      dto: UserDto,
                                                      context: NSManagedObjectContext) -> (N?, NSManagedObjectContext) {        
        var entity: N?
        context.performAndWait {
            entity = type.fetchFirst(attributeName: #keyPath(BaseUserEntity.name),
                                           attributeValue: dto.username,
                                           context: context)
            
            if entity == nil {
                entity = type.init(context: context)
                entity?.identifier = UUID().uuidString
                entity?.createdAt = Date()
            }
            
            entity?.updatedAt = Date()
            entity?.name = dto.nick
            entity?.userName = dto.username
            entity?.avatar = dto.avatar
            entity?.profile = dto.profile
        }
        
        return (entity, context)
    }
}
