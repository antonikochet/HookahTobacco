//
//  Request+Authorization.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation

struct LoginRequest {
    let email: String
    let username: String
    let password: String
}

extension LoginRequest: Encodable {
    func encode(to encoder: Encoder) throws {
        var contrainer = encoder.container(keyedBy: CodingKeys.self)
        if !email.isEmpty {
            try contrainer.encode(email, forKey: .email)
        }
        if !username.isEmpty {
            try contrainer.encode(username, forKey: .username)
        }
        try contrainer.encode(password, forKey: .password)
    }

    enum CodingKeys: String, CodingKey {
        case email, username, password
    }
}
