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
        view.showAlertError(with: message)
    }
}

extension LoginPresenter: LoginViewOutputProtocol {
    func pressedButtonLogin(with login: String?, and password: String?) {
        guard let email = login, !email.isEmpty else {
            view.showAlertForUnspecifiedField(with: "Ошибка", message: "email не введен", error: .login)
            return
        }
        guard let pass = password, !pass.isEmpty else {
            view.showAlertForUnspecifiedField(with: "Ошибка", message: "пароль не введен", error: .password)
            return
        }
        
        interactor.userLoginSystem(with: email, and: pass)
    }
}
