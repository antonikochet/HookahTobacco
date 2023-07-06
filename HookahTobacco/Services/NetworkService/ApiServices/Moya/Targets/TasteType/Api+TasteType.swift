//
//  Api+TasteType.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    enum TasteType {
        case list
        case detail(id: String)
        case create
        case update(id: String)
    }
}

extension Api.TasteType: DefaultTarget {

    var path: String {
        switch self {
        case .list, .create:
            return "v1/taste_type/"
        case let .detail(id):
            return "v1/taste_type/\(id)"
        case let .update(id):
            return "v1/taste_type/\(id)"
        }
    }

    var method: Method {
        switch self {
        case .create:
            return .post
        case .list, .detail:
            return .get
        case .update:
            return .patch
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}
