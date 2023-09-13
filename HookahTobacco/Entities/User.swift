//
//  User.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation

enum Gender: Int, CaseIterable {
    case notPicked
    case male
    case female

    var name: String {
        switch self {
        case .notPicked:
            return "Не выбрано"
        case .male:
            return "Мужской"
        case .female:
            return "Женский"
        }
    }
}

struct User: UserProtocol {
    var uid: Int
    var username: String
    var email: String
    var firstName: String?
    var lastName: String?
    var isAdmin: Bool
    var dateOfBirth: Date?
    var gender: Gender?
}
