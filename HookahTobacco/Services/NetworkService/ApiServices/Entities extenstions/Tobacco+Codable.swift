//
//  Tobacco+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

private struct ManufacturerForTobacco: Decodable {
    let id: Int
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

extension Tobacco: DataNetworkingServiceProtocol { }

extension Tobacco: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .uid))
        uid = String(try container.decode(Int.self, forKey: .uid))
        name = try container.decode(String.self, forKey: .name)
        tastes = try container.decode([Taste].self, forKey: .tastes)
        let manufacturer = try container.decode(ManufacturerForTobacco.self, forKey: .manufacturer)
        idManufacturer = String(manufacturer.id)
        nameManufacturer = manufacturer.name
        description = try container.decode(String.self, forKey: .description)
        line = try container.decode(TobaccoLine.self, forKey: .line)
        imageURL = try container.decode(URL?.self, forKey: .imageURL)?.absoluteString ?? ""
        isFavorite = false
        isWantBuy = false
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case tastes
        case manufacturer
        case description = "desctiption"
        case imageURL = "image_url"
        case line
    }
}
