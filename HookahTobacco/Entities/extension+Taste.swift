//
//  extension+Taste.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//

import HookahTobaccoCore

extension Taste {
    init(taste: String, typeTaste: [TasteType]) {
        self.init(id: -1, taste: taste, typeTaste: typeTaste)
    }
}

extension Taste: Hashable {
    public static func == (_ lhs: Taste, rhs: Taste) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Taste: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if id != -1 {
            try container.encode(id, forKey: .id)
        }
        try container.encode(taste, forKey: .taste)
        try container.encode(typeTaste.map({ $0.id }), forKey: .typeTaste)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(id: try container.decode(Int.self, forKey: .id),
                  taste: try container.decode(String.self, forKey: .taste),
                  typeTaste: try container.decode([TasteType].self, forKey: .typeTaste))
    }

    enum CodingKeys: String, CodingKey {
        case id
        case taste
        case typeTaste = "type"
    }
}
