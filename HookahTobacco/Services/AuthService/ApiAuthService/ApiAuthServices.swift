//
//  ApiAuthServices.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Moya

final class ApiAuthServices: BaseApiService {

    // MARK: - Private properties
    private let settings: AuthSettingsProtocol

    // MARK: - Init
    init(provider: MoyaProvider<MultiTarget>,
         settings: AuthSettingsProtocol,
         handlerErrors: NetworkHandlerErrors) {
        self.settings = settings
        super.init(provider: provider, authSettings: settings, handlerErrors: handlerErrors)
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
        let target = Api.Authorization.login(request)
        sendRequest(object: LoginResponse.self, target: target) { [weak self] response in
            self?.settings.setToken(response.token)
            completion?(nil)
        } failure: { error in
            completion?(error)
        }

    }

    func logout(completion: AuthServiceCompletion?) {
        let target = Api.Authorization.logout
        sendRequest(object: EmptyResponse.self, target: target) { [weak self] _ in
            self?.settings.setToken(nil)
            completion?(nil)
        } failure: { error in
            completion?(error)
        }
    }
}

extension ApiAuthServices: RegistrationServiceProtocol {
    func checkRegistrationData(email: String?, username: String?, completion: CompletionBlockWithParam<HTError?>?) {
        let request = CheckRegistrationRequest(email: email, username: username)
        let target = Api.Registration.check(request)
        sendRequest(object: EmptyResponse.self, target: target) { result in
            switch result {
            case .success:
                completion?(nil)
            case .failure(let error):
                completion?(error)
            }
        }
    }

    func registration(user: RegistrationUserProtocol, completion: CompletionBlockWithParam<HTError?>?) {
        let target = Api.Registration.registration(user)
        sendRequest(object: LoginResponse.self, target: target) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.settings.setToken(response.token)
                completion?(nil)
            case let .failure(error):
                completion?(error)
            }
        }
    }
}
