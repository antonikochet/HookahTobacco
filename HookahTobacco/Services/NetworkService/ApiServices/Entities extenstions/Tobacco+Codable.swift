//
//  Tobacco+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

private struct ManufacturerForTobacco: Decodable {
    let id: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

extension Tobacco: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = try container.decode(String.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        tastes = try container.decode([Taste].self, forKey: .tastes)
        let manufacturer = try container.decode(ManufacturerForTobacco.self, forKey: .manufacturer)
        idManufacturer = manufacturer.id
        nameManufacturer = manufacturer.name
        description = try container.decode(String.self, forKey: .description)
        line = try container.decode(TobaccoLine.self, forKey: .line)
        isFavorite = false
        isWantBuy = false
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case tastes
        case manufacturer
        case description
        case line
    }
}
