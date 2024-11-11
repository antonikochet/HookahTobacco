//
//  CheckRegistrationDTO.swift
//
//
//  Created by Anton Kochetkov on 12.08.2023.
//

public struct CheckRegistrationDTO: Encodable {
    public let email: String
    public let username: String
    public let password: String
    
    public init(
        email: String,
        username: String,
        password: String
    ) {
        self.email = email
        self.username = username
        self.password = password
    }
}
