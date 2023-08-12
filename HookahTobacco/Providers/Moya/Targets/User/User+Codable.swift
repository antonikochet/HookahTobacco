//
//  User+Codable.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation

extension User: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        uid = String(try container.decode(Int.self, forKey: .uid))
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        firstName = try container.decode(String?.self, forKey: .firstName)
        lastName = try container.decode(String?.self, forKey: .lastName)
        isAdmin = try container.decode(Bool.self, forKey: .isAdmin)
    }

    enum CodingKeys: String, CodingKey {
        case uid = "id"
        case username
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case isAdmin = "is_admin"
    }
}
