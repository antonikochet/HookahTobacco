//
//  ApiAuthServices.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Moya

final class ApiAuthServices {

    // MARK: - Private properties
    private let provider: MoyaProvider<MultiTarget>
    private let settings: AuthSettingsProtocol
    private let handlerErrors: AuthHandlerErrors

    // MARK: - Init
    init(provider: MoyaProvider<MultiTarget>,
         settings: AuthSettingsProtocol,
         handlerErrors: AuthHandlerErrors) {
        self.provider = provider
        self.settings = settings
        self.handlerErrors = handlerErrors
    }

    // MARK: - Public methods

    // MARK: - Private methods

}

extension ApiAuthServices: AuthServiceProtocol {
    var isLoggedIn: Bool {
        !(settings.getToken()?.isEmpty ?? true)
    }

    func login(with name: String, password: String, completion: AuthServiceCompletion?) {
        let isEmail = name.isEmailValid()
        let request = LoginRequest(email: isEmail ? name : "",
                                   username: isEmail ? "" : name,
                                   password: password)
        let target = MultiTarget(Api.Authorization.login(request))
        provider.request(object: LoginResponse.self, target: target) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.settings.setToken(response.token)
                completion?(nil)
            case let .failure(error):
                let authError = self.handlerErrors.handlerError(error)
                completion?(authError)
            }
        }
    }

    func logout(completion: AuthServiceCompletion?) {
        let target = MultiTarget(Api.Authorization.logout)
        provider.request(object: EmptyResponse.self, target: target) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                self.settings.setToken(nil)
                completion?(nil)
            case .failure(let error):
                let authError = self.handlerErrors.handlerError(error)
                completion?(authError)
            }
        }
    }
}

extension ApiAuthServices: RegistrationServiceProtocol {
    func checkRegistrationData(email: String?, username: String?, completion: RegistrationServiceCompletion?) {
        let request = CheckRegistrationRequest(email: email, username: username)
        let target = MultiTarget(Api.Registration.check(request))
        provider.request(object: EmptyResponse.self, target: target) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success:
                completion?(nil)
            case .failure(let error):
                let authError = self.handlerErrors.handlerError(error)
                completion?(authError)
            }
        }
    }

    func registration(user: RegistrationUserProtocol, completion: RegistrationServiceCompletion?) {
        let target = MultiTarget(Api.Registration.registration(user))
        provider.request(object: LoginResponse.self, target: target) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.settings.setToken(response.token)
                completion?(nil)
            case let .failure(error):
                let authError = self.handlerErrors.handlerError(error)
                completion?(authError)
            }
        }
    }
}
