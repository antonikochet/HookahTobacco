//
//  Manufacturer+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

extension Manufacturer: DataNetworkingServiceProtocol { }

extension Manufacturer: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = String(try container.decode(Int.self, forKey: .uid))
        name = try container.decode(String.self, forKey: .name)
        country = try container.decode(String.self, forKey: .country)
        description = try container.decode(String.self, forKey: .description)
        link = try container.decode(String.self, forKey: .link)
        urlImage = try container.decode(URL.self, forKey: .nameImage).absoluteString
        lines = try container.decode([TobaccoLine].self, forKey: .lines)
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case country
        case description
        case link
        case nameImage = "image_url"
        case lines = "tobacco_lines"
    }
}
