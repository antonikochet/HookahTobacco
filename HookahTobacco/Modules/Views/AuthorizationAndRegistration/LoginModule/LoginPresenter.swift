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
        view.hideLoading()
        router.showProfileView()
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        router.showError(with: error.message)
    }
}

extension LoginPresenter: LoginViewOutputProtocol {
    func pressedButtonLogin(with login: String?, and password: String?) {
        var isError = false
        var email = login ?? ""
        var pass = password ?? ""
        if email.isEmpty {
            view.showEmailError(R.string.localizable.loginLoginErrorMessage())
            isError = true
        }
        if pass.isEmpty {
            view.showPasswordError(R.string.localizable.loginPasswordErrorMessage())
            isError = true
        }
        if isError {
            return
        }
        interactor.userLoginSystem(with: email, and: pass)
        view.showBlockLoading()
    }

    func pressedButtonRegistration() {
        router.showRegistrationView()
    }
}
