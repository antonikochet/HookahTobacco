//
//  Api+User.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Moya

extension Api {
    enum Users {
        case get
        case patch
        case changePassword
        case resetPassword
        case getFavoritesTobacco
        case getBuyToTobacco
        case updateFavoriteTobaccos([UpdateTobaccosUser])
        case updateWantBuyTobaccos([UpdateTobaccosUser])
    }
}

extension Api.Users: DefaultTarget {
    var path: String {
        switch self {
        case .get, .patch:
            return "v1/user/"
        case .changePassword:
            return "v1/user/password/change/"
        case .resetPassword:
            return "v1/user/password/reset/"
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
        case .get, .getFavoritesTobacco, .getBuyToTobacco:
            return .get
        case .patch:
            return .patch
        case .changePassword, .resetPassword, .updateFavoriteTobaccos, .updateWantBuyTobaccos:
            return .post
        }
    }

    var task: Moya.Task {
        switch self {
        case .updateFavoriteTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        case .updateWantBuyTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        default:
            return .requestPlain
        }
    }
}
