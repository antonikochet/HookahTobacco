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

    func receivedError(_ error: HTError) {
        view.hideLoading()
        if case let .apiError(apiErrors) = error {
            apiErrors.forEach { error in
                if error.fieldName == User.CodingKeys.username.rawValue {
                    view.showFieldError(error.message, field: .username)
                } else if error.fieldName == User.CodingKeys.email.rawValue {
                    view.showFieldError(error.message, field: .email)
                } else {
                    router.showError(with: error.message)
                }
            }
        } else {
            router.showError(with: error.message)
        }
    }
}

// MARK: - ViewOutputProtocol implementation
extension RegistrationPresenter: RegistrationViewOutputProtocol {
    func pressedRegistrationButton(username: String, email: String, pass: String, repeatPass: String) {
        var isError = false
        if username.isEmpty {
            view.showFieldError(R.string.localizable.registrationTextFieldEmptyErrorMessage(), field: .username)
            isError = true
        }
        if email.isEmpty {
            view.showFieldError(R.string.localizable.registrationTextFieldEmptyErrorMessage(), field: .email)
            isError = true
        } else if !email.isEmailValid() {
            view.showFieldError(R.string.localizable.registrationEmailNotValidMessage(), field: .email)
            isError = true
        }
        if pass.isEmpty {
            view.showFieldError(R.string.localizable.registrationTextFieldEmptyErrorMessage(), field: .password)
            isError = true
        }
        if repeatPass.isEmpty {
            view.showFieldError(R.string.localizable.registrationTextFieldEmptyErrorMessage(), field: .repearPassword)
            isError = true
        } else if pass != repeatPass {
            view.showFieldError(R.string.localizable.registrationPasswordNotEqualsMessage(), field: .repearPassword)
            isError = true
        }
        // TODO: добавить проверку ввода пароля
        guard !isError, !username.isEmpty, !email.isEmpty, !pass.isEmpty, !repeatPass.isEmpty else {
            return
        }

        self.username = username
        self.email = email
        self.password = pass
        view.showBlockLoading()
        interactor.sendCheckRegistrationData(username: username, email: email)
    }
}
