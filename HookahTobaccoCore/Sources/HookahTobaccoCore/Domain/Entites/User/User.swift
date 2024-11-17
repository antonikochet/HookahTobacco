//
//  User.swift
//
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import HookahTobaccoNetwork

public struct User {
    public let id: Int
    public let username: String
    public let email: String
    public let firstName: String?
    public let lastName: String?
    public let isAdmin: Bool
    public let dateOfBirth: Date?
    public let gender: Gender
    
    internal init(dto: UserDTO) {
        self.id = dto.id
        self.username = dto.username
        self.email = dto.email
        self.firstName = dto.first_name
        self.lastName = dto.last_name
        self.isAdmin = dto.is_admin
        var dateOfBirth: Date?
        if let date_of_birth = dto.date_of_birth {
            dateOfBirth = TextFormatter.createDate(from: date_of_birth, format: .shortDate)
        }
        self.dateOfBirth = dateOfBirth
        self.gender = Gender(rawValue: dto.gender)
    }
    
    public enum Field: String {
        case username
        case email
        case password
    }
}
