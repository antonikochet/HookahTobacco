//
//  TobaccoLine.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.11.2022.
//

import HookahTobaccoCore

extension VarietyTobaccoLeaf: CaseIterable {
    public static var allCases: [VarietyTobaccoLeaf] = [.burley, .oriental, .virginia]
    
    var name: String {
        switch self {
        case .burley:
            return "Берли"
        case .virginia:
            return "Вирджиния"
        case .oriental:
            return "Ориентал"
        }
    }

    var description: String {
        switch self {
        case .burley:
            return """
                Берли – лист для крепких смесей. Он нарезан мелко, ароматизатор впитывает быстро,\
                уровень жаростойкости низкий. Вариант для любителей кальяна с опытом.
                """
        case .virginia:
            return "Ориентал средней нарезки подходит, как для крепких, так и для легких смесей."
        case .oriental:
            return """
                Вирджиния – крупно нарезанный лист с необычным вкусом, используется для подготовки\
                табака путем сушки сырья дымом.
                """
        }
    }
}

extension TobaccoType: CaseIterable {
    public static var allCases: [TobaccoType] = [.tobacco, .nonTobaccoBlend]
    
    var name: String {
        switch self {
        case .tobacco:
            return "Табак"
        case .nonTobaccoBlend:
            return "Беcтабачная смесь"
        }
    }
}

// MARK: - Codable

extension TobaccoType: Codable {

}

extension VarietyTobaccoLeaf: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(self.rawValue))
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self),
           let val = VarietyTobaccoLeaf(rawValue: intValue) {
            self = val
        } else if let strValue = try? container.decode(String.self) {
            switch strValue {
            case "Burley":
                self = .burley
            case "Oriental":
                self = .oriental
            case "Virginia":
                self = .virginia
            default:
                throw DecodingError.typeMismatch(
                    String.self,
                    .init(codingPath: [],
                          debugDescription: "Failed to decode value \(strValue) to type VarietyTobaccoLeaf")
                )
            }
        } else {
            throw DecodingError.typeMismatch(
                String.self,
                .init(codingPath: [],
                      debugDescription: "Failed to decode value to type VarietyTobaccoLeaf")
            )
        }
    }
}

extension TobaccoLine: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if id != -1 {
            try container.encode(id, forKey: .id)
        }
        try container.encode(name, forKey: .name)
        try container.encode(packetingFormat.map({ String($0) }).joined(separator: ", "), forKey: .packetingFormat)
        try container.encode(tobaccoType.rawValue, forKey: .tobaccoType)
        try container.encode(tobaccoLeafType?.map { $0.rawValue } ?? [], forKey: .tobaccoLeafType)
        try container.encode(description, forKey: .description)
        try container.encode(isBase, forKey: .isBase)
        try container.encode(manufacturerId, forKey: .manufacturer)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.init(id: try container.decode(Int.self, forKey: .id),
                  name: try container.decode(String.self, forKey: .name),
                  packetingFormat: try container.decode(String.self, forKey: .packetingFormat)
                    .split(separator: ",")
                    .compactMap { Int($0) },
                  tobaccoType: try container.decode(TobaccoType.self, forKey: .tobaccoType),
                  tobaccoLeafType: try container.decode([VarietyTobaccoLeaf]?.self, forKey: .tobaccoLeafType),
                  description: try container.decode(String.self, forKey: .description),
                  isBase: try container.decode(Bool.self, forKey: .isBase),
                  manufacturerId: try container.decode(Int.self, forKey: .manufacturer))
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case packetingFormat = "packeting_format"
        case tobaccoType = "tobacco_type"
        case tobaccoLeafType = "tobacco_leaf_type"
        case description
        case isBase = "is_base"
        case manufacturer
    }
}
