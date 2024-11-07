//
//  Api+Authorization.swift
//
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Moya

extension Api {
    public enum Authorization {
        case login(LoginRequestDTO)
        case logout
    }
}

extension Api.Authorization: DefaultTarget {
    public var path: String {
        switch self {
        case .login:
            return "v1/auth/login/"
        case .logout:
            return "v1/auth/logout/"
        }
    }

    public var method: Moya.Method {
        .post
    }

    public var task: Moya.Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .logout:
            return .requestPlain
        }
    }
}
