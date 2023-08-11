//
//  Api+Countries.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    enum Countries {
        case list
        case detail(id: String)
        case create(Country)
        case update(id: String, Country)
        case delete(id: String)
    }
}

extension Api.Countries: DefaultTarget {

    var path: String {
        switch self {
        case .list, .create:
            return "v1/country/"
        case let .detail(id):
            return "v1/country/\(id)/"
        case let .update(id, _):
            return "v1/country/\(id)/"
        case let .delete(id):
            return "v1/country/\(id)/"
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
        case .create(let country):
            return .requestJSONEncodable(country)
        case .update(_, let country):
            return .requestJSONEncodable(country)
        default:
            return .requestPlain
        }
    }
}
