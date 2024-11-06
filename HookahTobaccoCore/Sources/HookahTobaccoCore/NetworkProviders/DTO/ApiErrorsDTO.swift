//
//  ApiErrorsDTO.swift
//
//
//  Created by Антон Кочетков on 06.11.2024.
//

struct ApiErrorsDTO: Decodable {
    let type: String
    let errors: [ApiErrorDTO]
}

struct ApiErrorDTO: Decodable {
    let error: String
    let message: String
    let field_name: String?
}
