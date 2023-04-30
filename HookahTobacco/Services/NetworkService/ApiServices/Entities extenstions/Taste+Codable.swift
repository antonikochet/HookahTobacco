//
//  Taste+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation

extension Taste: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = String(try container.decode(Int.self, forKey: .uid))
        taste = try container.decode(String.self, forKey: .taste)
        let tasteTypes = try container.decode([TasteType].self, forKey: .typeTaste)
        typeTaste = tasteTypes.first!.name
//        typeTaste = try container.decode(TasteType.self, forKey: .typeTaste) // TODO: - переделать на TasteType
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case taste
        case typeTaste = "type"
    }
}
