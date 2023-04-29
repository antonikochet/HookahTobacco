//
//  Manufacturer+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

extension Manufacturer: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
        description = try container.decode(String.self, forKey: .description)
        link = try container.decode(String.self, forKey: .link)
        nameImage = try container.decode(String.self, forKey: .nameImage)
        lines = try container.decode([TobaccoLine].self, forKey: .lines)
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case country
        case description
        case link
        case nameImage = "url_image"
        case lines = "tobacco_lines"
    }
}
