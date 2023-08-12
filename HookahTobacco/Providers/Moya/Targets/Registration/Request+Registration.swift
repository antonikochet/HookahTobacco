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
    var image: Data?
}
