//
//  Tobacco.swift
//
//
//  Created by антон кочетков on 03.08.2022.
//

import Foundation
import HookahTobaccoNetwork

public struct Tobacco {
    public let id: Int
    public let name: String
    public let tastes: [Taste]
    public let manufacturerID: Int
    public let manufacturerName: String
    public let description: String
    public let line: TobaccoLine
    public let imageURL: String
    public var isFavorite: Bool
    public var isWantBuy: Bool
    public var image: Data?

    public var isFlagsChanged: Bool = false
    
    public init(
        id: Int = -1,
        name: String,
        tastes: [Taste],
        manufacturerID: Int,
        manufacturerName: String,
        description: String,
        line: TobaccoLine,
        imageURL: String,
        isFavorite: Bool = false,
        isWantBuy: Bool = false,
        image: Data? = nil) {
        self.id = id
        self.name = name
        self.tastes = tastes
        self.manufacturerID = manufacturerID
        self.manufacturerName = manufacturerName
        self.description = description
        self.line = line
        self.imageURL = imageURL
        self.isFavorite = isFavorite
        self.isWantBuy = isWantBuy
        self.image = image
    }
    
    public init(dto: TobaccoDTO) {
        self.id = dto.id
        self.name = dto.name
        self.tastes = dto.tastes.map { .init(dto: $0) }
        self.manufacturerID = dto.manufacturer.id
        self.manufacturerName = dto.manufacturer.name
        self.description = dto.description ?? ""
        self.line = TobaccoLine(dto: dto.line)
        self.imageURL = dto.image_url
        self.isFavorite = dto.is_favorite
        self.isWantBuy = dto.is_want_buy
    }
}
