//
//  Country+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import Foundation

extension Country: DataNetworkingServiceProtocol { }

extension Country: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
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
