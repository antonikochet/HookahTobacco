//
//  Api+Registration.swift
//
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation
import Moya

extension Api {
    public enum Registration {
        case check(CheckRegistrationDTO)
        case registration(RegistrationUserDTO)
        case verifyEmail
        case resendEmail
    }
}

extension Api.Registration: DefaultTarget {
    public var path: String {
        switch self {
        case .check:
            return "v1/auth/registration/check/"
        case .registration:
            return "v1/auth/registration/"
        case .verifyEmail:
            return "v1/auth/registration/verify-email/"
        case .resendEmail:
            return "v1/auth/registration/resend-email/"
        }
    }

    public var method: Moya.Method {
        .post
    }

    public var task: Moya.Task {
        switch self {
        case .check(let request):
            return .requestJSONEncodable(request)
        case .registration(let request):
            return .requestJSONEncodable(request)
        default:
            return .requestPlain
        }
    }
}
