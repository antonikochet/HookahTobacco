//
//  extention + Encodable.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 09.05.2023.
//

import Foundation

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(
            with: data,
            options: .allowFragments
        ) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}
