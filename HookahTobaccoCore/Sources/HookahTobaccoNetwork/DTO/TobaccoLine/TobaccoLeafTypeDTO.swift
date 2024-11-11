//
//  TobaccoLeafTypeDTO.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct TobaccoLeafTypeDTO: Decodable {
    public let value: Int
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let intValue = try? container.decode(Int.self) {
            self.value = intValue
        } else if let strValue = try? container.decode(String.self) {
            let value: Int
            switch strValue {
            case "Burley":
                value = 0
            case "Oriental":
                value = 1
            case "Virginia":
                value = 2
            default:
                throw DecodingError.typeMismatch(
                    String.self,
                    .init(codingPath: [],
                          debugDescription: "Failed to decode value \(strValue) to type VarietyTobaccoLeaf")
                )
            }
            self.value = value
        } else {
            throw DecodingError.typeMismatch(
                String.self,
                .init(codingPath: [],
                      debugDescription: "Failed to decode value to type VarietyTobaccoLeaf")
            )
        }
    }
}
