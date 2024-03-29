//
//  TasteType+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation

extension TasteType: DataNetworkingServiceProtocol { }

extension TasteType: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if uid != -1 {
            try container.encode(uid, forKey: .uid)
        }
        try container.encode(name, forKey: .name)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .uid))
        uid = try container.decode(Int.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
    }

    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
    }
}
