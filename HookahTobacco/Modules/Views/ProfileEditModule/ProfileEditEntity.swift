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
    }

    struct User {
        let firstName: String
        let lastName: String
        let dateOfBirth: Date?
    }
}
