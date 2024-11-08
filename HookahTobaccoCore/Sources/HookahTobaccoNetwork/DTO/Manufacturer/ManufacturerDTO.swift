//
//  ManufacturerDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct ManufacturerDTO: Decodable {
    public let id: Int
    public let name: String
    public let country: CountryDTO
    public let description: String
    public let image_url: String
    public let link: String?
    public let tobacco_lines: [TobaccoLineDTO]
}
