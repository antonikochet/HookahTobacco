//
//  CreatedAppeal.swift
//  
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation

public struct CreatedAppeal {
    public let id: Int
    public let name: String
    public let email: String
    public let theme: String
    public let createdDate: Date
    
    internal init(dto: CreatedAppealDTO) {
        self.id = dto.id
        self.name = dto.name
        self.email = dto.email
        self.theme = dto.theme
        self.createdDate = TextFormatter.createDate(from: dto.created_date, format: "yyyy-MM-dd'T'HH:mm:ssZZZZZ")
    }
}
