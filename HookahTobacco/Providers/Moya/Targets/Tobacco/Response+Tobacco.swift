//
//  Response+Tobacco.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//

import Foundation

struct TobaccoFilterResponse: Decodable {
    let manufacturer: [ManufacturerForTobacco]
    let tasteType: [TasteType]
    let tastes: [TasteFilter]
    let tobaccoType: [TobaccoType]
    let count: Int

    enum CodingKeys: String, CodingKey {
        case manufacturer
        case tasteType = "taste_type"
        case tastes
        case tobaccoType = "tobacco_type"
        case count
    }
}

extension TasteFilter: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        taste = try container.decode(String.self, forKey: .taste)
    }

    enum CodingKeys: String, CodingKey {
        case id, taste
    }
}

extension TobaccoFilters {
    init(_ response: TobaccoFilterResponse) {
        manufacturer = response.manufacturer
        tasteType = response.tasteType
        tastes = response.tastes
        tobaccoType = response.tobaccoType
        count = response.count
    }
}
