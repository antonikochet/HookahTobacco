//
//
//  LoginViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 15.11.2024.
//
//

import Foundation
import HookahTobaccoCore

protocol LoginViewModel: ObservableObject, BaseViewModel {
    var email: String { get set }
    var emailError: String { get set }
    var password: String { get set }
    var passwordError: String { get set }
    
    func login()
    func registration()
}

final class LoginViewModelImpl: BaseViewModelImpl, LoginViewModel {
    // MARK: - ViewModel properties
    @Published var email: String = ""
    @Published var emailError: String = ""
    @Published var password: String = ""
    @Published var passwordError: String = ""
    
    // MARK: - Private properties
    
    // MARK: - Dependency
    private let authService: AuthServiceProtocol
    
    // MARK: - Routing
    private var showProfile: VoidBlock
    private var showRegistration: VoidBlock
    
    // MARK: - Initializers
    init(
        authService: AuthServiceProtocol,
        showProfile: @escaping VoidBlock,
        showRegistration: @escaping VoidBlock
    ) {
        self.authService = authService
        self.showProfile = showProfile
        self.showRegistration = showRegistration
        super.init()
    }
    
    // MARK: - ViewModel methods
    func login() {
        var isError = false
        if email.isEmpty {
            emailError = R.string.localizable.loginLoginErrorMessage()
            isError = true
        }
        if password.isEmpty {
            passwordError = R.string.localizable.loginPasswordErrorMessage()
            isError = true
        }
        if isError {
            return
        }
        
        networkRequest { [weak self] in
            guard let self else { return }
            try await self.authService.login(with: email, password: password)
            await MainActor.run {
                self.showProfile()
            }
        } errorClosure: { error in
            await MainActor.run { [weak self] in
                self?.showAlertError(message: error.message)
            }
        }
    }
    
    func registration() {
        showRegistration()
    }
    // MARK: - Private methods
}

#if DEBUG
final class LoginViewModelMock: BaseViewModelImpl, LoginViewModel {
    // MARK: - ViewModel properties
    @Published var email: String = ""
    @Published var emailError: String = ""
    @Published var password: String = ""
    @Published var passwordError: String = ""
    
    // MARK: - ViewModel methods
    func login() {
        
    }
    
    func registration() {
        
    }
}
#endif
