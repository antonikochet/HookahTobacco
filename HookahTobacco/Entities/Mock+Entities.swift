//
//  Mock+Entities.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 04.07.2024.
//

import Foundation

extension Tobacco {
    static var mock: Self {
        .init(
            name: "Test Tobacco",
            tastes: [Taste.mock],
            idManufacturer: 1,
            nameManufacturer: "Test Tobacco Manufacturer",
            description: "Test Tobacco description Test Tobacco description Test Tobacco description Test Tobacco description Test Tobacco description",
            line: TobaccoLine.mock,
            imageURL: "http://127.0.0.1:8000/media/images/manufacturers/Adalya.png",
            isFavorite: false,
            isWantBuy: false
        )
        }
}

extension Taste {
    static var mock: Self {
        .init(
            taste: "Test Taste",
            typeTaste: [TasteType.mock]
        )
    }
}

extension TasteType {
    static var mock: Self {
        .init(name: "Test TasteType")
    }
}

extension TobaccoLine {
    static var mock: Self {
        .init(
            name: "Test TobaccoLine",
            packetingFormat: [100, 150],
            tobaccoType: .tobacco,
            tobaccoLeafType: [VarietyTobaccoLeaf.burley],
            description: "Test TobaccoLine description", 
            isBase: true
        )
    }
}
