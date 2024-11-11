//
//  UpdateTobaccosUserDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation

public struct UpdateTobaccosUserDTO: Encodable {
    public let id: Int
    public let flag: Bool
    
    public init(id: Int, flag: Bool) {
        self.id = id
        self.flag = flag
    }
}
