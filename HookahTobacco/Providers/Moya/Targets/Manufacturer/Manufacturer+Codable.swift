//
//  Manufacturer+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

extension Manufacturer: DataNetworkingServiceProtocol { }

extension Manufacturer: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if uid != -1 {
            try container.encode(uid, forKey: .uid)
        }
        try container.encode(name, forKey: .name)
        try container.encode(country.uid, forKey: .countryId)
        try container.encode(description, forKey: .description)
        if let link {
            try container.encode(link, forKey: .link)
        }
        try container.encode(lines.compactMap { Int($0.uid) }, forKey: .lines)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .uid))
        uid = try container.decode(Int.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(Country.self, forKey: .country)
        description = try container.decode(String.self, forKey: .description)
        link = try container.decode(String.self, forKey: .link)
        urlImage = try container.decode(URL.self, forKey: .nameImage).absoluteString
        lines = try container.decode([TobaccoLine].self, forKey: .lines)
    }

    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case country
        case countryId = "country_id"
        case description
        case link
        case nameImage = "image_url"
        case lines = "tobacco_lines"
    }
}
