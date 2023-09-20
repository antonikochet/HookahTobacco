//
//
//  CreateAppealsEntity.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import Foundation

enum ContentType {
    case photo
    case video
}

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

    struct Content {
        let url: URL
        /// size in value bytes
        let size: Int
        let type: ContentType
    }
}
