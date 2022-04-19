//
//  MappingData.swift
//  
//
//  Created by Gabriel Vermesan on 11.04.2022.
//

import Foundation

extension Encodable {
    public func toJSON() -> [String: Any] {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        if let data = try? encoder.encode(self) {
            return try! JSONSerialization.jsonObject(with: data) as? [String: Any] ?? [:]
        }
        return [:]
    }
}
