//
//  Response+Appeals.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//

import Foundation

// MARK: - getThemes
struct ThemesAppealsResponse: Decodable {
    let themes: [ThemeAppeal]
    let user: ThemeAppealUser?
}

struct ThemeAppeal: Decodable {
    let id: Int
    let name: String
    let isContent: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case isContent = "is_content"
    }
}

struct ThemeAppealUser: Decodable {
    let id: Int
    let name: String
    let email: String
}

// MARK: - createAppeal
struct CreateAppealResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let theme: String
    let createdDate: Date

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case theme
        case createdDate = "created_date"
    }
}
