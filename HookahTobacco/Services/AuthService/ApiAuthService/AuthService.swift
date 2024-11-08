//
//  AuthService.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 11.08.2023.
//

import Foundation
import Moya
import HookahTobaccoCore

final class AuthService {

    // MARK: - Private properties
    private let authRepo: AuthorizationRepoProtocol
    private let registrationRepo: RegistrationRepoProtocol
    private let settings: AuthSettingsProtocol

    // MARK: - Init
    init(authRepo: AuthorizationRepoProtocol,
         registrationRepo: RegistrationRepoProtocol,
         settings: AuthSettingsProtocol) {
        self.authRepo = authRepo
        self.registrationRepo = registrationRepo
        self.settings = settings
    }

    // MARK: - Public methods

    // MARK: - Private methods

}

extension AuthService: AuthServiceProtocol {
    var isLoggedIn: Bool {
        !(settings.getToken()?.isEmpty ?? true)
    }

    func login(with name: String, password: String, completion: AuthServiceCompletion?) {
        authRepo.login(with: name, password: password) { [weak self] result in
            switch result {
            case .success(let login):
                self?.settings.setToken(login.token)
                completion?(nil)
            case .failure(let error):
                completion?(HTError.createError(error))
            }
            
        }
    }

    func logout(completion: AuthServiceCompletion?) {
        authRepo.logout { [weak self] error in
            guard let error else {
                self?.settings.setToken(nil)
                return
            }
            completion?(HTError.createError(error))
        }
    }
}

extension AuthService: RegistrationServiceProtocol {
    func checkRegistrationData(email: String, username: String, password: String, completion: BlockWithParam<HTError?>?) {
        registrationRepo.checkRegistrationData(email: email, username: username, password: password) { error in
            guard let error else {
                completion?(nil)
                return
            }
            completion?(HTError.createError(error))
        }
    }

    func registration(user: HookahTobaccoCore.RegistrationUser, completion: BlockWithParam<HTError?>?) {
        registrationRepo.registration(user: user) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(response):
                self.settings.setToken(response.token)
                completion?(nil)
            case let .failure(error):
                completion?(HTError.createError(error))
            }
        }
    }
}
