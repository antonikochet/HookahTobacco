//
//  TasteDTO.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct TasteDTO: Decodable {
    public let id: Int
    public let taste: String
    public let type: [TasteTypeDTO]
}
