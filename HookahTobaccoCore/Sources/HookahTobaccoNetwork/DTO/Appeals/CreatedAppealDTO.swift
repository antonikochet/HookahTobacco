//
//  CreatedAppealDTO.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

public struct CreatedAppealDTO: Decodable {
    public let id: Int
    public let name: String
    public let email: String
    public let theme: String
    public let created_date: String
}
