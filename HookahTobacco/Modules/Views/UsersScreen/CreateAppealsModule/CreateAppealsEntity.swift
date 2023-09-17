//
//
//  CreateAppealsEntity.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import Foundation

struct CreateAppealsEntity {
    struct ViewModel {
        let name: String
        let email: String
    }

    struct EnterData {
        let name: String
        let email: String
        let message: String
    }
}
