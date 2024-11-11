//
//  AppealEntity.swift
//  
//
//  Created by Антон Кочетков on 07.11.2024.
//

import Foundation
import HookahTobaccoCore
import HookahTobaccoNetwork

public struct AppealEntity {
    public let id: Int
    public let name: String
    public let email: String
    public let theme: ThemeAppeal
    public let message: String
    public let contents: [AppealContent]
    public let createdDate: Date
    public let status: AppealStatus
    public let handledDate: Date?
    public let replyMessage: String
    
    internal init(dto: AppealDTO) {
        self.id = dto.id
        self.name = dto.name
        self.email = dto.email
        self.theme = ThemeAppeal(dto: dto.theme)
        self.message = dto.message
        self.contents = dto.contents.map { .init(dto: $0) }
        self.createdDate = TextFormatter.createDate(from: dto.created_date, format: .fullServer)
        self.status = AppealStatus(dto: dto.status)
        if let handledDate = dto.handled_date {
            self.handledDate = TextFormatter.createDate(from: handledDate, format: .fullServer)
        } else {
            self.handledDate = nil
        }
        self.replyMessage = dto.reply_message
    }
}

public struct AppealContent: Decodable {
    public let file: String
    
    init(dto: AppealContentDTO) {
        self.file = dto.file
    }
}
