//
//  TobaccoLine.swift
//
//
//  Created by антон кочетков on 28.11.2022.
//

import HookahTobaccoNetwork

public struct TobaccoLine {
    public let id: Int
    public let name: String
    public let packetingFormat: [Int]
    public let tobaccoType: TobaccoType
    public let tobaccoLeafType: [VarietyTobaccoLeaf]?
    public let description: String
    public let isBase: Bool
    public let manufacturerId: Int
    
    public init(
        id: Int = -1,
        name: String,
        packetingFormat: [Int],
        tobaccoType: TobaccoType,
        tobaccoLeafType: [VarietyTobaccoLeaf]?,
        description: String,
        isBase: Bool,
        manufacturerId: Int
    ) {
        self.id = id
        self.name = name
        self.packetingFormat = packetingFormat
        self.tobaccoType = tobaccoType
        self.tobaccoLeafType = tobaccoLeafType
        self.description = description
        self.isBase = isBase
        self.manufacturerId = manufacturerId
    }
    
    public init(dto: TobaccoLineDTO) {
        self.id = dto.id
        self.name = dto.name
        self.packetingFormat = dto.packeting_format.split(separator: ",").compactMap { Int($0) }
        self.tobaccoType = TobaccoType(rawValue: dto.tobacco_type) ?? .tobacco
        self.tobaccoLeafType = dto.tobacco_leaf_type?.compactMap { VarietyTobaccoLeaf(rawValue: $0.value) }
        self.description = dto.description
        self.isBase = dto.is_base
        self.manufacturerId = dto.manufacturer
    }
}

public enum TobaccoType: Int {
    case tobacco = 0
    case nonTobaccoBlend
}

public enum VarietyTobaccoLeaf: Int {
    case burley = 0
    case virginia
    case oriental
}
