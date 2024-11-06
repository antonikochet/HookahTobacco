//
//  ThemesAppealDTO.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

import Foundation

struct ThemesAppealDTO: Decodable {
    let themes: [ThemeAppealDTO]
    let user: ThemeAppealUserDTO?
}

struct ThemeAppealDTO: Codable {
    let id: Int
    let name: String
    let is_content: Bool
}

struct ThemeAppealUserDTO: Decodable {
    let id: Int
    let name: String
    let email: String
}
