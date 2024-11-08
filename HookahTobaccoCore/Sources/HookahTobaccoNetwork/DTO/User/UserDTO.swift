//
//  UserDTO.swift
//
//
//  Created by Антон Кочетков on 08.11.2024.
//

public struct UserDTO: Decodable {
    public let id: Int
    public let username: String
    public let email: String
    public let first_name: String?
    public let last_name: String?
    public let is_admin: Bool
    public let date_of_birth: String?
    public let gender: Int?
    
    public init(
        uid: Int,
        username: String,
        email: String,
        first_name: String?,
        last_name: String?,
        is_admin: Bool,
        date_of_birth: String?,
        gender: Int?
    ) {
        self.id = uid
        self.username = username
        self.email = email
        self.first_name = first_name
        self.last_name = last_name
        self.is_admin = is_admin
        self.date_of_birth = date_of_birth
        self.gender = gender
    }
}
