//
//  Taste.swift
//
//
//  Created by антон кочетков on 12.11.2022.
//

import HookahTobaccoNetwork

public struct Taste {
    public let id: Int
    public let taste: String
    public let typeTaste: [TasteType]
    
    public init(id: Int = -1, taste: String, typeTaste: [TasteType]) {
        self.id = id
        self.taste = taste
        self.typeTaste = typeTaste
    }
    
    public init(dto: TasteDTO) {
        self.id = dto.id
        self.taste = dto.taste
        self.typeTaste = dto.type.map { .init(dto: $0) }
    }
}

extension TasteChangeDTO {
    public init(taste: Taste) {
        self.init(
            id: taste.id,
            taste: taste.taste,
            typeTaste: taste.typeTaste.map { $0.id })
    }
}
