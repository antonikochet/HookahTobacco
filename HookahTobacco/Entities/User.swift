//
//  User.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation

struct User: UserProtocol {
    var uid: Int
    var username: String
    var email: String
    var firstName: String?
    var lastName: String?
    var isAdmin: Bool
    var dateOfBirth: Date?
}
