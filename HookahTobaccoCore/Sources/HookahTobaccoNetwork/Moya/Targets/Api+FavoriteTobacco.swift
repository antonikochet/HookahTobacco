//
//  Api+FavoriteTobacco.swift
//
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Moya

extension Api {
    public enum FavoriteTobacco {
        case getFavoritesTobacco(page: Int)
        case updateFavoriteTobaccos([UpdateTobaccosUserDTO])
    }
}

extension Api.FavoriteTobacco: DefaultTarget {
    public var path: String {
        switch self {
        case .getFavoritesTobacco:
            return "v1/user/favorite_tobacco/"
        case .updateFavoriteTobaccos:
            return "v1/user/update-favorite-tobacco/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getFavoritesTobacco:
            return .get
        case .updateFavoriteTobaccos:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .getFavoritesTobacco(let page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding())
        case .updateFavoriteTobaccos(let tobaccos):
            return .requestJSONEncodable(tobaccos)
        }
    }
}
