//
//  Api+Countries.swift
//
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    public enum Country {
        case list
        case detail(id: Int)
        case create(CountryChangeDTO)
        case update(id: Int, CountryChangeDTO)
        case delete(id: Int)
    }
}

extension Api.Country: DefaultTarget {
    public var path: String {
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
        case .create(let country):
            return .requestJSONEncodable(country)
        case .update(_, let country):
            return .requestJSONEncodable(country)
        default:
            return .requestPlain
        }
    }
}
