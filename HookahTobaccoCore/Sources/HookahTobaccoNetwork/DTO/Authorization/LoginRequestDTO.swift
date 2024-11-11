//
//  LoginRequestDTO.swift
//
//
//  Created by Антон Кочетков on 07.11.2024.
//

public struct LoginRequestDTO: Encodable {
    public let email: String?
    public let username: String?
    public let password: String
    
    public init(
        email: String?,
        username: String?,
        password: String
    ) {
        self.email = email
        self.username = username
        self.password = password
    }
}
