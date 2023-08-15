//
//  TobaccoLine+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

extension TobaccoType: Codable {

}

extension VarietyTobaccoLeaf: Codable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(String(self.rawValue))
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let strValue = try container.decode(String.self)
        switch strValue {
        case "\(VarietyTobaccoLeaf.burley.rawValue)":
            self = .burley
        case "\(VarietyTobaccoLeaf.oriental.rawValue)":
            self = .oriental
        case "\(VarietyTobaccoLeaf.virginia.rawValue)":
            self = .virginia
        default:
            throw DecodingError.typeMismatch(
                String.self,
                .init(codingPath: [],
                      debugDescription: "Failed to decode value \(strValue) to type VarietyTobaccoLeaf")
            )
        }
    }
}

extension TobaccoLine: DataNetworkingServiceProtocol { }

extension TobaccoLine: Codable {

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if uid != -1 {
            try container.encode(uid, forKey: .uid)
        }
        try container.encode(name, forKey: .name)
        try container.encode(packetingFormat.map({ String($0) }).joined(separator: ", "), forKey: .packetingFormat)
        try container.encode(tobaccoType, forKey: .tobaccoType)
        try container.encode(tobaccoLeafType ?? [], forKey: .tobaccoLeafType)
        try container.encode(description, forKey: .description)
        try container.encode(isBase, forKey: .isBase)
        if let manufacturerId {
            try container.encode(manufacturerId, forKey: .manufacturer)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = String(try container.decode(Int.self, forKey: .uid))
        uid = try container.decode(Int.self, forKey: .uid)
        name = try container.decode(String.self, forKey: .name)
        packetingFormat = try container.decode(String.self, forKey: .packetingFormat)
            .split(separator: ",")
            .compactMap { Int($0) }
        tobaccoType = try container.decode(TobaccoType.self, forKey: .tobaccoType)
        tobaccoLeafType = try container.decode([VarietyTobaccoLeaf]?.self, forKey: .tobaccoLeafType)
        description = try container.decode(String.self, forKey: .description)
        isBase = try container.decode(Bool.self, forKey: .isBase)
        manufacturerId = try container.decode(Int.self, forKey: .manufacturer)
    }

    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case packetingFormat = "packeting_format"
        case tobaccoType = "tobacco_type"
        case tobaccoLeafType = "tobacco_leaf_type"
        case description
        case isBase = "is_base"
        case manufacturer
    }
}
