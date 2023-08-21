//
//  Taste+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation

extension Taste: DataNetworkingServiceProtocol { }

extension Taste: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if uid != -1 {
            try container.encode(uid, forKey: .uid)
        }
        try container.encode(taste, forKey: .taste)
        try container.encode(typeTaste.map({ $0.uid }), forKey: .typeTaste)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .uid))
        uid = try container.decode(Int.self, forKey: .uid)
        taste = try container.decode(String.self, forKey: .taste)
        typeTaste = try container.decode([TasteType].self, forKey: .typeTaste)
    }

    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case taste
        case typeTaste = "type"
    }
}
