//
//  extension+TasteType.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import HookahTobaccoCore

extension TasteType {
    init(name: String) {
        self.init(id: -1, name: name)
    }
}

extension TasteType: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if id != -1 {
            try container.encode(id, forKey: .id)
        }
        try container.encode(name, forKey: .name)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(id: try container.decode(Int.self, forKey: .id),
                  name: try container.decode(String.self, forKey: .name))
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name
    }
}
