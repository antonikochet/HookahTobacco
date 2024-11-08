//
//  ManufacturerForTobacco.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public struct ManufacturerForTobacco {
    public let id: Int
    public let name: String
    
    public init(dto: ManufacturerForTobaccoDTO) {
        self.id = dto.id
        self.name = dto.name
    }
}
