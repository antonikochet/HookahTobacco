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

// MARK: - getList
struct AppealResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let theme: ThemeAppeal
    let message: String
    let contents: [AppealContent]
    let createdDate: Date
    let status: AppealStatus
    let handledDate: Date?
    let replyMessage: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case theme
        case createdDate = "created_date"
        case message
        case contents
        case status
        case handledDate = "handled_date"
        case replyMessage = "reply_message"
    }
}

struct AppealContent: Decodable {
    let file: String
}

enum AppealStatus: Int, Decodable, CaseIterable {
    case notViewed = 0
    case processing
    case handled
}
