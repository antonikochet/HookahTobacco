//
//
//  RegistrationViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 17.11.2024.
//
//

import Foundation
import HookahTobaccoCore

protocol RegistrationViewModel: BaseViewModel, ObservableObject {
    var username: String { get set }
    var usernameError: String { get set }
    var email: String { get set }
    var emailError: String { get set }
    var password: String { get set }
    var passwordError: String { get set }
    var repeatPassword: String { get set }
    var repeatPasswordError: String { get set }
    
    func continueRegistration()
}

final class RegistrationViewModelImpl: BaseViewModelImpl, RegistrationViewModel {
    // MARK: - ViewModel properties
    @Published var username: String = ""
    @Published var usernameError: String = ""
    @Published var email: String = ""
    @Published var emailError: String = ""
    @Published var password: String = ""
    @Published var passwordError: String = ""
    @Published var repeatPassword: String = ""
    @Published var repeatPasswordError: String = ""
    
    // MARK: - Private properties
    
    // MARK: - Dependency
    private let registrationService: RegistrationServiceProtocol
    
    // MARK: - Router
    private let showProfileRegistration: BlockWithParam<RegistrationUser>
    
    // MARK: - Initializers
    init(
        registrationService: RegistrationServiceProtocol,
        showProfileRegistration: @escaping BlockWithParam<RegistrationUser>
    ) {
        self.registrationService = registrationService
        self.showProfileRegistration = showProfileRegistration
    }
    
    // MARK: - ViewModel methods
    func continueRegistration() {
        var isError = false
        if username.isEmpty {
            usernameError = R.string.localizable.registrationTextFieldEmptyErrorMessage()
            isError = true
        }
        if email.isEmpty {
            emailError = R.string.localizable.registrationTextFieldEmptyErrorMessage()
            isError = true
        } else if !email.isEmailValid() {
            emailError = R.string.localizable.registrationEmailNotValidMessage()
            isError = true
        }
        if password.isEmpty {
            passwordError = R.string.localizable.registrationTextFieldEmptyErrorMessage()
            isError = true
        }
        if repeatPassword.isEmpty {
            repeatPasswordError = R.string.localizable.registrationTextFieldEmptyErrorMessage()
            isError = true
        } else if password != repeatPassword {
            repeatPasswordError = R.string.localizable.registrationPasswordNotEqualsMessage()
            isError = true
        }
        guard !isError else { return }
        
        networkRequest { [weak self] in
            guard let self else { return }
            try await self.registrationService.checkRegistrationData(
                email: self.email,
                username: self.username,
                password: self.password
            )
            await MainActor.run {
                let user = RegistrationUser(
                    username: self.username,
                    email: self.email,
                    password: self.password)
                self.showProfileRegistration(user)
            }
        } errorClosure: { [weak self] error in
            await self?.handlerError(error)
        }
    }
    
    // MARK: - Private methods
    @MainActor
    private func handlerError(_ error: DomainError) {
        guard case let .error(apiErrors) = error else {
            showAlertError(message: error.message)
            return
        }
        apiErrors.forEach { error in
            switch error.fieldName {
            case User.Field.username.rawValue:
                usernameError = error.message
            case User.Field.email.rawValue:
                emailError = error.message
            case User.Field.password.rawValue:
                passwordError = error.message
            default:
                showAlertError(message: error.message)
            }
        }
    }
}

#if DEBUG
final class RegistrationViewModelMock: BaseViewModelImpl, RegistrationViewModel {
    // MARK: - ViewModel properties
    @Published var username: String = ""
    @Published var usernameError: String = ""
    @Published var email: String = ""
    @Published var emailError: String = ""
    @Published var password: String = ""
    @Published var passwordError: String = ""
    @Published var repeatPassword: String = ""
    @Published var repeatPasswordError: String = ""
    
    // MARK: - ViewModel methods
    func continueRegistration() {
        
    }
}
#endif
