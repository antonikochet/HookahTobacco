//
//  Api+User.swift
//
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Moya

extension Api {
    public enum Users {
        case get
        case patch(RegistrationUserDTO)
        case changePassword
        case resetPassword
        case getUrls(AgreementURLsRequestDTO)
    }
}

extension Api.Users: DefaultTarget {
    public var path: String {
        switch self {
        case .get, .patch:
            return "v1/user/"
        case .changePassword:
            return "v1/user/password/change/"
        case .resetPassword:
            return "v1/user/password/reset/"
        case .getUrls:
            return "v1/urls/"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .get:
            return .get
        case .patch:
            return .patch
        case .changePassword, .resetPassword, .getUrls:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .patch(let user):
            return .requestJSONEncodable(user)
        case .getUrls(let request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }
}
