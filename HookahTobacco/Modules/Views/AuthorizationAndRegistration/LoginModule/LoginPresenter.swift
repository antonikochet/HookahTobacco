//
//
//  LoginPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import Foundation

class LoginPresenter {
    weak var view: LoginViewInputProtocol!
    var interactor: LoginInteractorInputProtocol!
    var router: LoginRouterProtocol!
}

extension LoginPresenter: LoginInteractorOutputProtocol {
    func receivedSuccessWhileLogin() {
        router.presentAddMenuView()
    }

    func receivedErrorLogin(with message: String) {
        router.showError(with: message)
    }
}

extension LoginPresenter: LoginViewOutputProtocol {
    func pressedButtonLogin(with login: String?, and password: String?) {
        guard let email = login, !email.isEmpty else {
            router.showError(with: "Логин не введен!")
            view.showEmptyField(field: .login)
            return
        }
        guard let pass = password, !pass.isEmpty else {
            router.showError(with: "Пароль не введен!")
            view.showEmptyField(field: .password)
            return
        }

        interactor.userLoginSystem(with: email, and: pass)
    }
}
