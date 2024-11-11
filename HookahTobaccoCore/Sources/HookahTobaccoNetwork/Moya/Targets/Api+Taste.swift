//
//  Api+Taste.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    public enum Taste {
        case list
        case detail(id: Int)
        case create(TasteChangeDTO)
        case update(id: Int, TasteChangeDTO)
        case delete(id: Int)
    }
}

extension Api.Taste: DefaultTarget {
    public var path: String {
        switch self {
        case .list, .create:
            return "v1/taste/"
        case let .detail(id):
            return "v1/taste/\(id)/"
        case let .update(id, _):
            return "v1/taste/\(id)/"
        case let .delete(id):
            return "v1/taste/\(id)/"
        }
    }

    public var method: Method {
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

    public var task: Task {
        switch self {
        case .create(let taste):
            return .requestJSONEncodable(taste)
        case .update(_, let taste):
            return .requestJSONEncodable(taste)
        default:
            return .requestPlain
        }
    }
}
