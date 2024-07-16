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
    
    static func mock(tasteCount: Int = 2, isFavorite: Bool = false, isWantBuy: Bool = false) -> Self {
        .init(
            name: "Test Tobacco",
            tastes: Taste.arrayMock(tasteCount),
            idManufacturer: 1,
            nameManufacturer: "Test Tobacco Manufacturer",
            description: "Test Tobacco description Test Tobacco description Test Tobacco description Test Tobacco description Test Tobacco description",
            line: TobaccoLine.mock,
            imageURL: "http://127.0.0.1:8000/media/images/manufacturers/Adalya.png",
            isFavorite: isFavorite,
            isWantBuy: isWantBuy
        )
    }
    
    static func arrayMock(_ count: Int = 2, tastesCount: Int = 2) -> [Self] {
        Array(repeating: Self.mock(tasteCount: tastesCount), count: count)
    }
}

extension Taste {
    static var mock: Self {
        mock()
    }
    
    static func mock(typeCount: Int = 1) -> Self {
        .init(
            taste: "Test Taste",
            typeTaste: TasteType.arrayMock(typeCount)
        )
    }
    
    static func arrayMock(_ count: Int = 2) -> [Self] {
        Array(repeating: Self.mock, count: count)
    }
}

extension TasteType {
    static var mock: Self {
        .init(name: "Test TasteType")
    }
    
    static func arrayMock(_ count: Int = 2) -> [Self] {
        Array(repeating: Self.mock, count: count)
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

extension Manufacturer {
    static var mock: Self {
        .init(
            name: "Test Manufacturer",
            country: Country.mock,
            description: "Test Manufacturer description Test Manufacturer description",
            urlImage: "http://127.0.0.1:8000/media/images/manufacturers/Must_Have.png",
            link: "http://test.test",
            lines: [.mock, .mock]
        )
    }
    
    static func arrayMock(_ count: Int = 4) -> [Self] {
        Array(repeating: Self.mock, count: count)
    }
}

extension Country {
    static var mock: Self {
        .init(name: "Test Country")
    }
}
