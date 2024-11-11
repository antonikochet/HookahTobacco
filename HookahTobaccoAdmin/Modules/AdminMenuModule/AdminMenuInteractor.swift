//
//
//  AdminMenuInteractor.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 08.10.2022.
//
//

import Foundation
import HookahTobaccoCore

protocol AdminMenuInteractorInputProtocol: AnyObject {
    func logout()
    func upgradeDBVersion()
}

protocol AdminMenuInteractorOutputProtocol: PresenterrProtocol {
    func receiveSuccessLogout()
    func showAlert()
}

class AdminMenuInteractor {
    // MARK: - Public properties
    weak var presenter: AdminMenuInteractorOutputProtocol!

    // MARK: - Dependency
    private let authService: AuthServiceProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }
}

// MARK: - AdminMenuInteractorInputProtocol implementation
extension AdminMenuInteractor: AdminMenuInteractorInputProtocol {
    func logout() {
        authService.logout { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receivedError(error)
                return
            }
            self.presenter.receiveSuccessLogout()
        }
    }

    func upgradeDBVersion() {
        
    }
}
