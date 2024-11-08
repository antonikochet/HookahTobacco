//
//  Manufacturer.swift
//
//
//  Created by антон кочетков on 16.09.2022.
//

import Foundation
import HookahTobaccoNetwork

public struct Manufacturer {
    public let id: Int
    public let name: String
    public let country: Country
    public let description: String
    public let urlImage: String
    public var image: Data? // TODO: - удалить, когде перенесу загрузку изображений в отдельный метод и вью
    public let link: String?
    public let lines: [TobaccoLine]
    
    public init(
        id: Int = -1,
        name: String,
        country: Country,
        description: String,
        urlImage: String,
        image: Data? = nil,
        link: String?,
        lines: [TobaccoLine]
    ) {
        self.id = id
        self.name = name
        self.country = country
        self.description = description
        self.urlImage = urlImage
        self.image = image
        self.link = link
        self.lines = lines
    }
    
    public init(dto: ManufacturerDTO) {
        self.id = dto.id
        self.name = dto.name
        self.country = Country(dto: dto.country)
        self.description = dto.description
        self.urlImage = dto.image_url
        self.image = nil
        self.link = dto.link
        self.lines = dto.tobacco_lines.map { TobaccoLine(dto: $0) }
    }
}
