//
//  Api+Appeals.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//

import Moya

extension Api {
    enum Appeals {
        case getThemes
        case createAppeal(CreateAppealRequest)
    }
}

extension Api.Appeals: DefaultTarget {
    var path: String {
        switch self {
        case .getThemes:
            return "api/v1/appeals/theme/"
        case .createAppeal:
            return "api/v1/appeals/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getThemes:
            return .get
        case .createAppeal:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .createAppeal(let request):
            return request.createRequest()
        default:
            return .requestPlain
        }
    }
}
