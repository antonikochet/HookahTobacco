//
//  Api+TasteType.swift
//
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    public enum TasteType {
        case list
        case detail(id: Int)
        case create(TasteTypeChangeDTO)
        case update(id: Int, TasteTypeChangeDTO)
    }
}

extension Api.TasteType: DefaultTarget {
    public var path: String {
        switch self {
        case .list, .create:
            return "v1/taste_type/"
        case let .detail(id):
            return "v1/taste_type/\(id)/"
        case let .update(id, _):
            return "v1/taste_type/\(id)/"
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
        }
    }

    public var task: Task {
        switch self {
        case .create(let tasteType):
            return .requestJSONEncodable(tasteType)
        case .update(_, let tasteType):
            return .requestJSONEncodable(tasteType)
        default:
            return .requestPlain
        }
    }
}
