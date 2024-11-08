//
//  Api+User.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Moya

extension Api {
    enum Users {
        case getFavoritesTobacco(page: Int)
        case getBuyToTobacco(page: Int)
        case updateFavoriteTobaccos([UpdateTobaccosUser])
        case updateWantBuyTobaccos([UpdateTobaccosUser])
    }
}

extension Api.Users: DefaultTarget {
    var path: String {
        switch self {
        case .getFavoritesTobacco:
            return "v1/user/favorite_tobacco/"
        case .getBuyToTobacco:
            return "v1/user/wish_tobaccos/"
        case .updateFavoriteTobaccos:
            return "v1/user/update-favorite-tobacco/"
        case .updateWantBuyTobaccos:
            return "v1/user/update-wish-tobacco/"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getFavoritesTobacco, .getBuyToTobacco:
            return .get
        case .updateFavoriteTobaccos, .updateWantBuyTobaccos:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .getFavoritesTobacco(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding())
        case .getBuyToTobacco(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding())
        case .updateFavoriteTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        case .updateWantBuyTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        }
    }
}
