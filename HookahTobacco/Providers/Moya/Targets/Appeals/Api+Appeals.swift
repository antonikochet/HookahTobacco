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
        case list(AppealFilterRequest)
        case updateAppeal(id: Int, answer: String)
        case handled(id: Int)
    }
}

extension Api.Appeals: DefaultTarget {
    var path: String {
        switch self {
        case .getThemes:
            return "v1/appeals/theme/"
        case .list:
            return "v1/appeals/"
        case .createAppeal:
            return "v1/appeals/create/"
        case .updateAppeal(let id, _):
            return "v1/appeals/\(id)/"
        case .handled:
            return "v1/appeals/handled/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getThemes:
            return .get
        case .createAppeal, .handled, .list:
            return .post
        case .updateAppeal:
            return .patch
        }
    }

    var task: Moya.Task {
        switch self {
        case .list(let request):
            return request.createRequest()
        case .createAppeal(let request):
            return request.createRequest()
        case .updateAppeal(_, let answer):
            return .requestParameters(parameters: ["reply_message": answer], encoding: JSONEncoding.default)
        case .handled(let id):
            return .requestParameters(parameters: ["id": id], encoding: JSONEncoding.default)
        default:
            return .requestPlain
        }
    }
}
