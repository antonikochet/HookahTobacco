//
//  Response+Tobacco.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//

import Foundation

struct TobaccoFilterResponse: Decodable {
    let manufacturer: [Manufacturer]
    let tasteType: [TasteType]
    let tastes: [Taste]
    let tobaccoType: [TobaccoType]

    enum CodingKeys: String, CodingKey {
        case manufacturer
        case tasteType = "taste_type"
        case tastes
        case tobaccoType = "tobacco_type"
    }
}

extension TobaccoFilters {
    init(_ response: TobaccoFilterResponse) {
        manufacturer = response.manufacturer
        tasteType = response.tasteType
        tastes = response.tastes
        tobaccoType = response.tobaccoType
    }
}
