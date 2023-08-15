//
//  Api+Manufacturer.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.07.2023.
//

import Moya

extension Api {
    enum Manufacturer {
        case list
        case detail(id: String)
        case create(ManufacturerRequest)
        case update(id: String, ManufacturerRequest)
        case tobaccos(id: String)
    }
}

extension Api.Manufacturer: DefaultTarget {

    var path: String {
        switch self {
        case .list, .create:
            return "v1/manufacturer/"
        case let .detail(id):
            return "v1/manufacturer/\(id)"
        case let .update(id, _):
            return "v1/manufacturer/\(id)"
        case let .tobaccos(id):
            return "v1/manufacturer/\(id)/tobaccos/"
        }
    }

    var method: Method {
        switch self {
        case .create:
            return .post
        case .list, .detail, .tobaccos:
            return .get
        case .update:
            return .patch
        }
    }

    var task: Task {
        switch self {
        case let .create(request):
            return request.createRequest()
        case let .update(_, request):
            return request.createRequest()
        default:
            return .requestPlain
        }
    }
}
