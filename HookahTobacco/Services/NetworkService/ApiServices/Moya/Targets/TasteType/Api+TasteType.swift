//
//  Api+TasteTypes.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    enum TasteTypes {
        case list
        case detail(id: String)
        case create(TasteType)
        case update(id: String, TasteType)
    }
}

extension Api.TasteTypes: DefaultTarget {

    var path: String {
        switch self {
        case .list, .create:
            return "v1/taste_type/"
        case let .detail(id):
            return "v1/taste_type/\(id)/"
        case let .update(id, _):
            return "v1/taste_type/\(id)/"
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
        case .create(let tasteType):
            return .requestJSONEncodable(tasteType)
        case .update(_, let tasteType):
            return .requestJSONEncodable(tasteType)
        default:
            return .requestPlain
        }
    }
}
