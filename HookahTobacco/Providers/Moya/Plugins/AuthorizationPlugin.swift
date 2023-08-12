//
//  AuthorizationPlugin.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 12.08.2023.
//

import Foundation
import Moya

struct AuthorizationPlugin: PluginType {
    
    private let authSettings: AuthSettingsProtocol
    
    init(authSettings: AuthSettingsProtocol) {
        self.authSettings = authSettings
    }
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let authToken = authSettings.getToken() else { return request }

        var request = request
        let authValue = "Token " + authToken
        request.addValue(authValue, forHTTPHeaderField: "Authorization")

        return request
    }
}

