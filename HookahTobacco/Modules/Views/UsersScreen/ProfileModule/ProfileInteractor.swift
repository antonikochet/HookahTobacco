//
//
//  ProfileInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.01.2023.
//
//

import Foundation
import HookahTobaccoCore

protocol ProfileInteractorInputProtocol: AnyObject {
    func receiveProfileInfo()
    func logout()
}

protocol ProfileInteractorOutputProtocol: PresenterrProtocol {
    func receivedProfileInfoSuccess(_ user: User)
    func receivedLogoutSuccess()
}

final class ProfileInteractor {
    // MARK: - Public properties
    weak var presenter: ProfileInteractorOutputProtocol!

    // MARK: - Dependency
    private let authService: AuthServiceProtocol
    private let userRepo: UserRepoProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(authService: AuthServiceProtocol,
         userRepo: UserRepoProtocol) {
        self.authService = authService
        self.userRepo = userRepo
    }

    // MARK: - Private methods

}
// MARK: - InputProtocol implementation 
extension ProfileInteractor: ProfileInteractorInputProtocol {
    func receiveProfileInfo() {
        userRepo.fetchUser { [weak self] result in
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
