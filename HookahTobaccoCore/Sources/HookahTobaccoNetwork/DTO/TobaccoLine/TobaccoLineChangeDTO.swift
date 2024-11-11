//
//  TobaccoLineChangeDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct TobaccoLineChangeDTO: Encodable {
    public let id: Int?
    public let name: String
    public let packeting_format: String
    public let tobacco_type: Int
    public let tobacco_leaf_type: [Int]
    public let description: String
    public let is_base: Bool
    public let manufacturer: Int?
    
    public init(
        id: Int?,
        name: String,
        packeting_format: String,
        tobacco_type: Int,
        tobacco_leaf_type: [Int],
        description: String,
        is_base: Bool,
        manufacturer: Int?
    ) {
        self.id = id
        self.name = name
        self.packeting_format = packeting_format
        self.tobacco_type = tobacco_type
        self.tobacco_leaf_type = tobacco_leaf_type
        self.description = description
        self.is_base = is_base
        self.manufacturer = manufacturer
    }
}
