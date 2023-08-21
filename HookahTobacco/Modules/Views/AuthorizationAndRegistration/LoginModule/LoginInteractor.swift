//
//
//  LoginInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

protocol LoginInteractorInputProtocol {
    func userLoginSystem(with login: String, and password: String)
}

protocol LoginInteractorOutputProtocol: PresenterrProtocol {
    func receivedSuccessWhileLogin()
}

class LoginInteractor {
    // MARK: - Public properties
    weak var presenter: LoginInteractorOutputProtocol!

    // MARK: - Dependency
    private let authService: AuthServiceProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}

extension LoginInteractor: LoginInteractorInputProtocol {
    func userLoginSystem(with login: String, and password: String) {
        authService.login(with: login, password: password) { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receivedError(error)
            } else {
                self.presenter.receivedSuccessWhileLogin()
            }
        }
    }
}
