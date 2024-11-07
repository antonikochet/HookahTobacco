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

public struct ApiErrorDTO: Decodable {
    public let error: String
    public let message: String
    public let field_name: String?
}
