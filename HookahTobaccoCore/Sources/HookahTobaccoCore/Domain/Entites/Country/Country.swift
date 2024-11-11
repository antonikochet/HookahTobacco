//
//  Country.swift
//  HookahTobacco
//
//  Created by антон кочетков on 30.04.2023.
//

import HookahTobaccoNetwork

public struct Country {
    public let id: Int
    public let name: String
    
    public init(id: Int = -1, name: String) {
        self.id = id
        self.name = name
    }
    
    public init(dto: CountryDTO) {
        self.id = dto.id
        self.name = dto.name
    }
}
