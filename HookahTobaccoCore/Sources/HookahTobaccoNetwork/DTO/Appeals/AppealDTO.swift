//
//  AppealDTO.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

public struct AppealDTO: Decodable {
    public let id: Int
    public let name: String
    public let email: String
    public let theme: ThemeAppealDTO
    public let message: String
    public let contents: [AppealContentDTO]
    public let created_date: String
    public let status: String
    public let handled_date: String?
    public let reply_message: String
}

public struct AppealContentDTO: Decodable {
    public let file: String
}
