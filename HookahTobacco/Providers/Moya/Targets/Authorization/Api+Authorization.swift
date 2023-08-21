//
//  Api+Authorization.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Moya

extension Api {
    enum Authorization {
        case login(LoginRequest)
        case logout
    }
}

extension Api.Authorization: DefaultTarget {
    var path: String {
        switch self {
        case .login:
            return "v1/auth/login/"
        case .logout:
            return "v1/auth/logout/"
        }
    }

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case .login(let request):
            return .requestJSONEncodable(request)
        case .logout:
            return .requestPlain
        }
    }
}
