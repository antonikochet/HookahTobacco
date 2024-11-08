//
//  RegistrationUser.swift
//  
//
//  Created by Антон Кочетков on 08.11.2024.
//

import Foundation

public struct RegistrationUser {
    public let username: String
    public let email: String
    public let password: String
    public let repeatPassword: String
    public let firstName: String?
    public let lastName: String?
    public let dateOfBirth: Date?
    public let gender: Gender?

    // TODO: - понять нужны ли эти свойства при переноси
//    public var isEdit: Bool = false
//    public var isEditUsername: Bool = false

    public init(
        username: String,
        email: String,
        password: String,
        repeatPassword: String,
        firstName: String? = nil,
        lastName: String? = nil,
        dateOfBirth: Date? = nil,
        gender: Gender? = nil
    ) {
        self.username = username
        self.email = email
        self.password = password
        self.repeatPassword = repeatPassword
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.gender = gender
    }
}
