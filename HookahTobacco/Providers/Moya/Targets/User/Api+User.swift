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
        case get
        case patch(RegistrationUserProtocol)
        case changePassword
        case resetPassword
        case getFavoritesTobacco(page: Int)
        case getBuyToTobacco(page: Int)
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
        case .patch(let user):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(DateFormatter(format: "yyyy-MM-dd"))
            return .requestCustomJSONEncodable(user, encoder: encoder)
        case .getFavoritesTobacco(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding())
        case .getBuyToTobacco(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding())
        case .updateFavoriteTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        case .updateWantBuyTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        default:
            return .requestPlain
        }
    }
}
