//
//  CreateAppealEntity.swift
//  
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation

public struct CreateAppealEntity {
    public let name: String
    public let email: String
    public let user: Int?
    public let theme: Int
    public let message: String
    public let contents: [URL]
    
    public init(
        name: String,
        email: String,
        user: Int?,
        theme: Int,
        message: String,
        contents: [URL]
    ) {
        self.name = name
        self.email = email
        self.user = user
        self.theme = theme
        self.message = message
        self.contents = contents
    }
    
    public enum Field: String {
        case name
        case email
        case theme
        case message
    }
}
