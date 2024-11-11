//
//  TobaccoFilter.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import HookahTobaccoNetwork

public struct TobaccoFilter {
    public var manufacturer: [ManufacturerForTobacco]
    public var tasteType: [TasteType]
    public var tastes: [TasteFilter]
    public var tobaccoType: [TobaccoType]
    public let count: Int
    
    public init() {
        self.manufacturer = []
        self.tasteType = []
        self.tastes = []
        self.tobaccoType = []
        self.count = 0
    }
    
    public init(dto: TobaccoFilterDTO) {
        self.manufacturer = dto.manufacturer.map { .init(dto: $0) }
        self.tasteType = dto.taste_type.map { .init(dto: $0) }
        self.tastes = dto.tastes.map { .init(dto: $0) }
        self.tobaccoType = dto.tobacco_type.compactMap { .init(rawValue: $0) }
        self.count = dto.count
    }
    
    public init(
        manufacturer: [ManufacturerForTobacco],
        tasteType: [TasteType],
        tastes: [TasteFilter],
        tobaccoType: [TobaccoType],
        count: Int
    ) {
        self.manufacturer = manufacturer
        self.tasteType = tasteType
        self.tastes = tastes
        self.tobaccoType = tobaccoType
        self.count = count
    }
}

extension TobaccoFilterRequestDTO {
    init?(filter: TobaccoFilter?) {
        guard let filter else { return nil }
        self.init(
            manufacturer: filter.manufacturer.isEmpty ? nil : filter.manufacturer.map { $0.id },
            taste_type: filter.tasteType.isEmpty ? nil : filter.tasteType.map { $0.id },
            tastes: filter.tastes.isEmpty ? nil : filter.tastes.map { $0.id },
            tobacco_type: filter.tobaccoType.isEmpty ? nil : filter.tobaccoType.map { $0.rawValue }
        )
    }
}
