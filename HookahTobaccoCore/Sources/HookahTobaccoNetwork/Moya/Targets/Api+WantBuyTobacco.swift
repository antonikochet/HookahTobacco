//
//  Api+WantBuyTobacco.swift
//
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Moya

extension Api {
    public enum WantBuyTobacco {
        case getBuyToTobacco(page: Int)
        case updateWantBuyTobaccos([UpdateTobaccosUserDTO])
    }
}

extension Api.WantBuyTobacco: DefaultTarget {
    public var path: String {
        switch self {
        case .getBuyToTobacco:
            return "v1/user/wish_tobaccos/"
        case .updateWantBuyTobaccos:
            return "v1/user/update-wish-tobacco/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getBuyToTobacco:
            return .get
        case .updateWantBuyTobaccos:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getBuyToTobacco(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding())
        case .updateWantBuyTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        }
    }
}

