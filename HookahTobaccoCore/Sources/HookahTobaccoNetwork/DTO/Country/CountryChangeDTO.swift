//
//  CountryChangeDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct CountryChangeDTO: Encodable {
    public let id: Int?
    public let name: String
    
    public init(id: Int?, name: String) {
        self.id = id
        self.name = name
    }
}
