//
//  Api+Registration.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation
import Moya

extension Api {
    enum Registration {
        case check(CheckRegistrationRequest)
        case registration(RegistrationUserProtocol)
        case verifyEmail
        case resendEmail
    }
}

extension Api.Registration: DefaultTarget {
    var path: String {
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

    var method: Moya.Method {
        .post
    }

    var task: Moya.Task {
        switch self {
        case .check(let request):
            return .requestJSONEncodable(request)
        case .registration(let request):
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .formatted(DateFormatter(format: "yyyy-MM-dd"))
            return .requestCustomJSONEncodable(request, encoder: encoder)
        default:
            return .requestPlain
        }
    }
}
