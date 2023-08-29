//
//  Tobacco.swift
//  HookahTobacco
//
//  Created by антон кочетков on 03.08.2022.
//

import Foundation

struct Tobacco {
    var id: String = ""
    var uid: Int = -1
    let name: String
    let tastes: [Taste]
    let idManufacturer: Int
    let nameManufacturer: String
    let description: String
    let line: TobaccoLine
    let imageURL: String
    var isFavorite: Bool
    var isWantBuy: Bool
    var image: Data?

    var isFlagsChanged: Bool = false
}

struct TobaccoFilters {
    var manufacturer: [Manufacturer]
    var tasteType: [TasteType]
    var tastes: [Taste]
    var tobaccoType: [TobaccoType]
}
