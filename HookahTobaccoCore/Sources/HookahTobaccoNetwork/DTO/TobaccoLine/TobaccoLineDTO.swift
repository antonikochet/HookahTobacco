//
//  TobaccoLineDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct TobaccoLineDTO: Decodable {
    public let id: Int
    public let name: String
    public let packeting_format: String
    public let tobacco_type: Int
    public let tobacco_leaf_type: [TobaccoLeafTypeDTO]?
    public let description: String
    public let is_base: Bool
    public let manufacturer: Int
}
