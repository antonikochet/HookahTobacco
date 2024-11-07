//
//  ThemesAppealDTO.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation

public struct ThemesAppealDTO: Decodable {
    public let themes: [ThemeAppealDTO]
    public let user: ThemeAppealUserDTO?
}

public struct ThemeAppealDTO: Codable {
    public let id: Int
    public let name: String
    public let is_content: Bool
}

public struct ThemeAppealUserDTO: Decodable {
    public let id: Int
    public let name: String
    public let email: String
}
