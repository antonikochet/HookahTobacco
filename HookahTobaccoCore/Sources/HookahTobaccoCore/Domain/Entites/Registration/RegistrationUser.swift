//
//  RegistrationUser.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation
import HookahTobaccoNetwork

public struct RegistrationUser {
    public let username: String
    public let email: String
    public let password: String
    public let firstName: String?
    public let lastName: String?
    public let dateOfBirth: Date?
    public let gender: Gender?

    public var isEdit: Bool = false
    public var isEditUsername: Bool = false

    public init(
        username: String,
        email: String,
        password: String,
        firstName: String? = nil,
        lastName: String? = nil,
        dateOfBirth: Date? = nil,
        gender: Gender? = nil
    ) {
        self.username = username
        self.email = email
        self.password = password
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
    }
    
    public init(user: User) {
        self.username = user.username
        self.email = user.email
        self.isEdit = true
        self.password = ""
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.dateOfBirth = user.dateOfBirth
        self.gender = user.gender
    }
}

extension RegistrationUserDTO {
    init(entity: RegistrationUser) {
        var date_of_birth: String?
        if let dateOfBirth = entity.dateOfBirth {
            date_of_birth = TextFormatter.dateToString(dateOfBirth, format: .shortDate)
        }
        self.init(
            username: entity.isEditUsername ? entity.username : nil,
            email: entity.email,
            password1: entity.isEdit ? entity.password : nil,
            password2: entity.isEdit ? entity.password : nil,
            first_name: entity.firstName ?? "",
            last_name: entity.lastName ?? "",
            date_of_birth: date_of_birth,
            gender: entity.gender?.rawValue
        )
    }
}
