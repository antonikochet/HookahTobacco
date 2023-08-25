//
//  Api+Tobacco.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Moya

extension Api {
    enum Tobacco {
        case list(page: Int)
        case create(TobaccoRequest)
        case update(id: Int, TobaccoRequest)
        case delete(id: Int)
    }
}

extension Api.Tobacco: DefaultTarget {

    var path: String {
        switch self {
        case .list, .create:
            return "v1/tobacco/"
        case let .update(id, _):
            return "v1/tobacco/\(id)/"
        case let .delete(id):
            return "v1/tobacco/\(id)/"
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
        case .delete:
            return .delete
        }
    }

    var task: Task {
        switch self {
        case let .list(page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding())
        case let .create(request):
            return request.createRequest()
        case let .update(_, request):
            return request.createRequest()
        default:
            return .requestPlain
        }
    }
}
