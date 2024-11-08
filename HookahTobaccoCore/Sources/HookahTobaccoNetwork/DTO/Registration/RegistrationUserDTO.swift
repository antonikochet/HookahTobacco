//
//  RegistrationUserDTO.swift
//
//
//  Created by Anton Kochetkov on 12.08.2023.
//

public struct RegistrationUserDTO: Encodable {
    public let username: String
    public let email: String
    public let password1: String
    public let password2: String
    public let first_name: String?
    public let last_name: String?
    public let date_of_birth: String?
    public let gender: Int?
    
    public init(
        username: String,
        email: String,
        password1: String,
        password2: String,
        first_name: String?,
        last_name: String?,
        date_of_birth: String?,
        gender: Int?
    ) {
        self.username = username
        self.email = email
        self.password1 = password1
        self.password2 = password2
        self.first_name = first_name
        self.last_name = last_name
        self.date_of_birth = date_of_birth
        self.gender = gender
    }
}
