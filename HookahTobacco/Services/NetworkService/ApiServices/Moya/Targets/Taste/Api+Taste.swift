//
//  Api+Taste.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    enum Taste {
        case list
        case detail(id: String)
        case create
        case update(id: String)
        case delete(id: String)
    }
}

extension Api.Taste: DefaultTarget {

    var path: String {
        switch self {
        case .list, .create:
            return "v1/taste/"
        case let .detail(id):
            return "v1/taste/\(id)"
        case let .update(id):
            return "v1/taste/\(id)"
        case let .delete(id):
            return "v1/taste/\(id)"
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
        case .delete:
            return .delete
        }
    }

    var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
}
