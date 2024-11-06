//
//  Response+Appeals.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//

import Foundation
import HookahTobaccoCore

// MARK: - getList
struct AppealResponse: Decodable {
    let id: Int
    let name: String
    let email: String
//    let theme: ThemeAppeal
    let message: String
    let contents: [AppealContent]
    let createdDate: Date
//    let status: AppealStatus
    let handledDate: Date?
    let replyMessage: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
//        case theme
        case createdDate = "created_date"
        case message
        case contents
//        case status
        case handledDate = "handled_date"
        case replyMessage = "reply_message"
    }
}

struct AppealContent: Decodable {
    let file: String
}
