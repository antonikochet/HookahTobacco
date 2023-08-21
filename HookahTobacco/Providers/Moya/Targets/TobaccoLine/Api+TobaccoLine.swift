//
//  Api+TobaccoLine.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    enum TobaccoLines {
        case list
        case create(TobaccoLine)
        case update(id: Int, TobaccoLine)
    }
}

extension Api.TobaccoLines: DefaultTarget {

    var path: String {
        switch self {
        case .list, .create:
            return "v1/tobacco_line/"
        case let .update(id, _):
            return "v1/tobacco_line/\(id)/"
        }
    }

    var method: Method {
        switch self {
        case .create:
            return .post
        case .list:
            return .get
        case .update:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case .create(let tobaccoLine):
            return .requestJSONEncodable(tobaccoLine)
        case .update(_, let tobaccoLine):
            return .requestJSONEncodable(tobaccoLine)
        default:
            return .requestPlain
        }
    }
}
