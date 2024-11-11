//
//  Api+TobaccoLine.swift
//
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    public enum TobaccoLine {
        case list
        case create(TobaccoLineChangeDTO)
        case update(id: Int, TobaccoLineChangeDTO)
    }
}

extension Api.TobaccoLine: DefaultTarget {
    public var path: String {
        switch self {
        case .list, .create:
            return "v1/tobacco_line/"
        case let .update(id, _):
            return "v1/tobacco_line/\(id)/"
        }
    }

    public var method: Method {
        switch self {
        case .create:
            return .post
        case .list:
            return .get
        case .update:
            return .patch
        }
    }

    public var task: Task {
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
