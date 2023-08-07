//
//
//  RegistrationPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//
//

import Foundation

final class RegistrationPresenter {
    // MARK: - Public properties
    weak var view: RegistrationViewInputProtocol!
    var interactor: RegistrationInteractorInputProtocol!
    var router: RegistrationRouterProtocol!

    // MARK: - Private properties

    // MARK: - Private methods

}

// MARK: - InteractorOutputProtocol implementation
extension RegistrationPresenter: RegistrationInteractorOutputProtocol {
    func receivedSuccessRegistration() {
        router.showProfileRegistrationView()
    }

    func receivedErrorRegistration(message: String) {
        router.showError(with: message)
    }
}

// MARK: - ViewOutputProtocol implementation
extension RegistrationPresenter: RegistrationViewOutputProtocol {
    func pressedRegistrationButton(email: String?, pass: String?, repeatPass: String?) {
        guard let email = email, !email.isEmpty else {
            router.showError(with: "Email не введен!")
            return
        }
        // TODO: добавить проверку ввода email
        guard let pass = pass, !pass.isEmpty else {
            router.showError(with: "Пароль не введен!")
            return
        }
        guard let repeatPass = repeatPass, !repeatPass.isEmpty else {
            router.showError(with: "Повторный пароль не введен!")
            return
        }
        // TODO: добавить проверку ввода пароля
        guard pass == repeatPass else {
            router.showError(with: "Введенные пароли различаются!")
            return
        }

        interactor.sendNewRegistrationData(email: email, pass: pass)
    }
}
