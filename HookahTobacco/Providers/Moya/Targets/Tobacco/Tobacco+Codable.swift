//
//  Tobacco+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

struct ManufacturerForTobacco: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}

extension Tobacco: DataNetworkingServiceProtocol { }

extension Tobacco: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if uid != -1 {
            try container.encode(uid, forKey: .uid)
        }
        try container.encode(name, forKey: .name)
        try container.encode(tastes.compactMap { Int($0.uid) }, forKey: .tastes)
        try container.encode(idManufacturer, forKey: .manufacturer)
        try container.encode(description, forKey: .description)
        try container.encode(line.uid, forKey: .lineId)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .uid))
        uid = try container.decode(Int.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        tastes = try container.decode([Taste].self, forKey: .tastes)
        let manufacturer = try container.decode(ManufacturerForTobacco.self, forKey: .manufacturer)
        idManufacturer = manufacturer.id
        nameManufacturer = manufacturer.name
        description = try container.decode(String.self, forKey: .description)
        line = try container.decode(TobaccoLine.self, forKey: .line)
        imageURL = try container.decode(URL?.self, forKey: .imageURL)?.absoluteString ?? ""
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        isWantBuy = try container.decode(Bool.self, forKey: .isWantBuy)
    }

    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case tastes
        case manufacturer
        case description = "desctiption"
        case imageURL = "image_url"
        case line
        case lineId = "line_id"
        case isFavorite = "is_favorite"
        case isWantBuy = "is_want_buy"
    }
}
