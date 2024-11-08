//
//  TobaccoDTO.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct TobaccoDTO: Decodable {
    public let id: Int
    public let name: String
    public let tastes: [TasteDTO]
    public let manufacturer: ManufacturerForTobaccoDTO
    public let description: String
    public let line: TobaccoLineDTO
    public let image_url: String
    public let is_favorite: Bool
    public let is_want_buy: Bool
}
