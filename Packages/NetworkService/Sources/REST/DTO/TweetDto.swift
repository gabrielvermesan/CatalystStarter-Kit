//
//  File.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Foundation

public struct TweetImageDto: Decodable {
    public let url: String
}

public struct TweetCommentDto: Decodable {
    public let content: String
    public let sender: UserDto
}

public struct TweetDto: Decodable {
    public let content: String?
    public let images: [TweetImageDto]?
    public let sender: UserDto
    public let comments: [TweetCommentDto]?
    
    public var isValid: Bool {
        content != nil || images?.isEmpty == false
    }
}

struct LossyDecodableList<Element: Decodable>: Decodable {
    let elements: [Element]
}

extension LossyDecodableList {
    private struct ElementWrapper: Decodable {
        var element: Element?

        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            element = try? container.decode(Element.self)
        }
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let wrappers = try container.decode([ElementWrapper].self)
        elements = wrappers.compactMap(\.element)
    }
}
