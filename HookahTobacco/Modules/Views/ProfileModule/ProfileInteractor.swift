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

protocol ProfileInteractorOutputProtocol: PresenterrProtocol {
    func receivedProfileInfoSuccess(_ user: UserProtocol)
    func receivedLogoutSuccess()
}

final class ProfileInteractor {
    // MARK: - Public properties
    weak var presenter: ProfileInteractorOutputProtocol!

    // MARK: - Dependency
    private let authService: AuthServiceProtocol
    private let userService: UserNetworkingServiceProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(authService: AuthServiceProtocol,
         userService: UserNetworkingServiceProtocol) {
        self.authService = authService
        self.userService = userService
    }

    // MARK: - Private methods

}
// MARK: - InputProtocol implementation 
extension ProfileInteractor: ProfileInteractorInputProtocol {
    func receiveProfileInfo() {
        userService.receiveUser { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                self.presenter.receivedProfileInfoSuccess(user)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    func logout() {
        authService.logout { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receivedError(error)
                return
            }
            self.presenter.receivedLogoutSuccess()
        }
    }
}
