//
//
//  ProfileEditEntity.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import Foundation

struct ProfileEditEntity {
    struct EnterData {
        let firstName: String
        let lastName: String
        let username: String
        let email: String
    }

    struct User {
        let firstName: String
        let lastName: String
        let username: String
        let email: String
        let dateOfBirth: Date?
        let gender: Gender?
    }
}
