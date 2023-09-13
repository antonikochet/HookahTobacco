//
//  Request+Registration.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation

struct CheckRegistrationRequest: Encodable {
    let email: String?
    let username: String?
}

struct RegistrationUser: RegistrationUserProtocol {
    var username: String
    var email: String
    var password: String
    var repeatPassword: String
    var firstName: String?
    var lastName: String?
    var dateOfBirth: Date?
    var gender: Gender?

    fileprivate var isEdit: Bool = false

    init(username: String,
         email: String,
         password: String,
         repeatPassword: String,
         firstName: String? = nil,
         lastName: String? = nil,
         dateOfBirth: Date? = nil,
         gender: Gender? = nil) {
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

extension RegistrationUser {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(username, forKey: .username)
        try container.encode(email, forKey: .email)
        if !isEdit {
            try container.encode(password, forKey: .password)
            try container.encode(repeatPassword, forKey: .repeatPassword)
        }
        try container.encode(firstName ?? "", forKey: .firstName)
        try container.encode(lastName ?? "", forKey: .lastName)
        try container.encodeIfPresent(dateOfBirth, forKey: .dateOfBirth)
    }

    enum CodingKeys: String, CodingKey {
        case username, email
        case password = "password1"
        case repeatPassword = "password2"
        case firstName = "first_name"
        case lastName = "last_name"
        case dateOfBirth = "date_of_birth"
        case image
    }
}

extension RegistrationUser {
    init(_ user: UserProtocol) {
        self.username = user.username
        self.email = user.email
        isEdit = true
        self.password = ""
        self.repeatPassword = ""
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.dateOfBirth = user.dateOfBirth
        self.gender = user.gender
    }
}
