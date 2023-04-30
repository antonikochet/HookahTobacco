//
//  TobaccoLine+Codable.swift
//  HookahTobacco
//
//  Created by антон кочетков on 22.04.2023.
//

import Foundation

extension TobaccoType: Decodable {
    
}

extension VarietyTobaccoLeaf: Decodable {
    
}

extension TobaccoLine: Decodable {
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = String(try container.decode(Int.self, forKey: .uid))
        name = try container.decode(String.self, forKey: .name)
        packetingFormat = try container.decode(String.self, forKey: .packetingFormat).split(separator: ",").compactMap { Int($0) } 
        tobaccoType = try container.decode(TobaccoType.self, forKey: .tobaccoType)
        tobaccoLeafType = try container.decode([VarietyTobaccoLeaf]?.self, forKey: .tobaccoLeafType)
        description = try container.decode(String.self, forKey: .description)
        isBase = try container.decode(Bool.self, forKey: .isBase)
    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case name
        case packetingFormat = "packeting_format"
        case tobaccoType = "tobacco_type"
        case tobaccoLeafType = "tobacco_leaf_type"
        case description
        case isBase = "is_base"
    }
}
