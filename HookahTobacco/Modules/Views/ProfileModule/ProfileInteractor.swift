//
//
//  ProfileInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.01.2023.
//
//

import Foundation

protocol ProfileInteractorInputProtocol: AnyObject {
    func receiveProfileInfo()
    func logout()
}

protocol ProfileInteractorOutputProtocol: AnyObject {
    func receivedProfileInfoSuccess(_ user: UserProtocol)
    func receivedProfileInfoError(_ message: String)
    func receivedLogoutSuccess()
    func receivedLogoutError(_ message: String)
}

final class ProfileInteractor {
    // MARK: - Public properties
    weak var presenter: ProfileInteractorOutputProtocol!

    // MARK: - Dependency
    private let authService: AuthServiceProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(authService: AuthServiceProtocol) {
        self.authService = authService
    }

    // MARK: - Private methods

}
// MARK: - InputProtocol implementation 
extension ProfileInteractor: ProfileInteractorInputProtocol {
    func receiveProfileInfo() {
        guard let user = authService.currectUser else {
            presenter.receivedProfileInfoError("") // TODO: написать ошибку
            return
        }
        presenter.receivedProfileInfoSuccess(user)
    }

    func logout() {
        authService.logout { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receivedLogoutError(error.localizedDescription)
                return
            }
            self.presenter.receivedLogoutSuccess()
        }
    }
}
