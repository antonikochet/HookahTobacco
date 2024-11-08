//
//  Api+Tobacco.swift
//
//
//  Created by Anton Kochetkov on 05.07.2023.
//

import Foundation
import Moya

extension Api {
    public enum Tobacco {
        case list(page: Int, search: String?, filter: TobaccoFilterRequestDTO?)
        case create(TobaccoRequestDTO)
        case update(id: Int, TobaccoRequestDTO)
        case delete(id: Int)
        case getFilter
        case updateFilter(TobaccoFilterRequestDTO)
    }
}

extension Api.Tobacco: DefaultTarget {
    public var path: String {
        switch self {
        case .list:
            return "v1/tobacco/"
        case .create:
            return "v1/tobacco/add/"
        case let .update(id, _):
            return "v1/tobacco/\(id)/"
        case let .delete(id):
            return "v1/tobacco/\(id)/"
        case .getFilter, .updateFilter:
            return "v1/tobacco/filter/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getFilter:
            return .get
        case .list, .create, .updateFilter:
            return .post
        case .update:
            return .patch
        case .delete:
            return .delete
        }
    }

    public var task: Task {
        switch self {
        case let .list(page, search, filter):
            var params: [String: Any] = [
                "page": page
            ]
            if let search {
                params["search"] = search
            }
            var bodyParams: [String: Any] = [:]
            if let filter {
                bodyParams = (try? filter.asDictionary()) ?? [:]
            }
            return .requestCompositeParameters(bodyParameters: bodyParams,
                                               bodyEncoding: JSONEncoding(),
                                               urlParameters: params)
        case let .create(request):
            return request.createRequest()
        case let .update(_, request):
            return request.createRequest()
        case let .updateFilter(request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }
}
