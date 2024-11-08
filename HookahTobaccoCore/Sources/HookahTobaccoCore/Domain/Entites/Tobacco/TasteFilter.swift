//
//  TasteFilter.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public struct TasteFilter {
    public let id: Int
    public let taste: String
    
    public init(id: Int, taste: String) {
        self.id = id
        self.taste = taste
    }
    
    public init(dto: TasteFilterDTO) {
        self.id = dto.id
        self.taste = dto.taste
    }
}
