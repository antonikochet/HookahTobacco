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

protocol LoginInteractorOutputProtocol: AnyObject {
    func receivedSuccessWhileLogin()
    func receivedErrorLogin(with message: String)
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
            if error == nil {
                self.presenter.receivedSuccessWhileLogin()
            } else {
                self.presenter.receivedErrorLogin(with: "Ошибка входа. \(error!.localizedDescription)")
            }
        }
    }
}
