//
//  AuthorizationPlugin.swift
//
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation
import Moya

public protocol AuthGettingProtocol {
    func getToken() -> String?
}

public struct AuthorizationPlugin: PluginType {

    private let authGettingProtocol: AuthGettingProtocol

    public init(authGettingProtocol: AuthGettingProtocol) {
        self.authGettingProtocol = authGettingProtocol
    }

    public func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authToken = authGettingProtocol.getToken() else { return request }

        var request = request
        let authValue = "Token " + authToken
        request.addValue(authValue, forHTTPHeaderField: "Authorization")

        return request
    }
}
