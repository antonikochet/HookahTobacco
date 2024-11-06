//
//  CreatedAppealDTO.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

struct CreatedAppealDTO: Decodable {
    let id: Int
    let name: String
    let email: String
    let theme: String
    let created_date: String
}
