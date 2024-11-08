//
//  TobaccoFilterDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct TobaccoFilterDTO: Decodable {
    public let manufacturer: [ManufacturerForTobaccoDTO]
    public let taste_type: [TasteTypeDTO]
    public let tastes: [TasteFilterDTO]
    public let tobacco_type: [Int]
    public let count: Int
}

