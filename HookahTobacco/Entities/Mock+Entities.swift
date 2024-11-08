//
//  Mock+Entities.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 04.07.2024.
//

import Foundation
import HookahTobaccoCore

extension Tobacco {
    
    static func mock(id: Int = 0, tasteCount: Int = 2, repeatDescription: Int = 3, isFavorite: Bool = false, isWantBuy: Bool = false) -> Self {
        .init(
            id: String(id),
            uid: id,
            name: "Test Tobacco",
            tastes: Taste.arrayMock(tasteCount),
            idManufacturer: 1,
            nameManufacturer: "Test Tobacco Manufacturer",
            description: Array(repeating: "Test Tobacco description", count: repeatDescription).joined(separator: " "),
            line: TobaccoLine.mock(),
            imageURL: "http://127.0.0.1:8000/media/images/manufacturers/Adalya.png",
            isFavorite: isFavorite,
            isWantBuy: isWantBuy
        )
    }
    
    static func arrayMock(_ count: Int = 2, tastesCount: Int = 2) -> [Self] {
        (0..<count).map { id in .mock(id: id, tasteCount: tastesCount) }
    }
}

extension Taste {
    static func mock(id: Int = 0, typeCount: Int = 1) -> Self {
        .init(
            id: id,
            taste: "Test Taste",
            typeTaste: TasteType.arrayMock(typeCount)
        )
    }
    
    static func arrayMock(_ count: Int = 2, typeCount: Int = 1) -> [Self] {
        (0..<count).map { id in Self.mock(id: id, typeCount: typeCount) }
    }
}

extension TasteType {
    static var mock: Self {
        .init(id: -1, name: "Test TasteType")
    }
    
    static func arrayMock(_ count: Int = 2) -> [Self] {
        Array(repeating: Self.mock, count: count)
    }
}

extension TobaccoLine {
    static func mock(id: Int = 0) -> Self {
        return .init(
            id: String(id),
            uid: id,
            name: "Test TobaccoLine \(id)",
            packetingFormat: [100, 150],
            tobaccoType: .tobacco,
            tobaccoLeafType: [VarietyTobaccoLeaf.burley],
            description: "Test TobaccoLine description",
            isBase: true
        )
    }
    
    static func arrayMock(_ count: Int = 3) -> [Self] {
        (0..<count).map { id in .mock(id: id) }
    }
}

extension Manufacturer {
    static func mock(id: Int = 0, countLines: Int = 2) -> Self {
        .init(
            id: String(id),
            uid: id,
            name: "Test Manufacturer",
            country: Country.mock,
            description: "Test Manufacturer description Test Manufacturer description",
            urlImage: "http://127.0.0.1:8000/media/images/manufacturers/Must_Have.png",
            link: "http://test.test",
            lines: (0..<countLines).map { id in TobaccoLine.mock(id: id) }
        )
    }
    
    static func arrayMock(_ count: Int = 4, countLines: Int = 2) -> [Self] {
        (0..<count).map { id in Self.mock(id: id, countLines: countLines) }
    }
}

extension Country {
    static var mock: Self {
        .init(name: "Test Country")
    }
}

private extension String {
    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }
}
