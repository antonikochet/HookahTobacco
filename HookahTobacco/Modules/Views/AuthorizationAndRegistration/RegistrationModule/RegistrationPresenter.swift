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
    private var email: String = ""
    private var username: String = ""
    private var password: String = ""

    // MARK: - Private methods

}

// MARK: - InteractorOutputProtocol implementation
extension RegistrationPresenter: RegistrationInteractorOutputProtocol {
    func receivedSuccessCheckRegistrationData() {
        view.hideLoading()
        let user = RegistrationUser(username: username,
                                    email: email,
                                    password: password,
                                    repeatPassword: password)
        router.showProfileRegistrationView(user: user)
    }

    func receivedErrorRegistration(message: String) {
        view.hideLoading()
        router.showError(with: message)
    }
}

// MARK: - ViewOutputProtocol implementation
extension RegistrationPresenter: RegistrationViewOutputProtocol {
    func pressedRegistrationButton(username: String, email: String, pass: String, repeatPass: String) {
        guard !username.isEmpty else {
            router.showError(with: "Имя пользователя не введено!")
            return
        }
        guard !email.isEmpty else {
            router.showError(with: "Email не введен!")
            return
        }
        guard email.isEmailValid() else {
            router.showError(with: "Email не валидный")
            return
        }
        guard !pass.isEmpty else {
            router.showError(with: "Пароль не введен!")
            return
        }
        guard !repeatPass.isEmpty else {
            router.showError(with: "Повторный пароль не введен!")
            return
        }
        // TODO: добавить проверку ввода пароля
        guard pass == repeatPass else {
            router.showError(with: "Введенные пароли различаются!")
            return
        }

        self.username = username
        self.email = email
        self.password = pass
        view.showBlockLoading()
        interactor.sendCheckRegistrationData(username: username, email: email)
    }
}
