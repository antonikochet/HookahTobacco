//
//
//  AdminMenuInteractor.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.10.2022.
//
//

import Foundation

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
    private let getDataManager: GetDataNetworkingServiceProtocol
    private let adminNetworkingService: AdminNetworkingServiceProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(authService: AuthServiceProtocol,
         getDataManager: GetDataNetworkingServiceProtocol,
         adminNetworkingService: AdminNetworkingServiceProtocol) {
        self.authService = authService
        self.getDataManager = getDataManager
        self.adminNetworkingService = adminNetworkingService
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
        getDataManager.getDataBaseVersion { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let version):
                self.adminNetworkingService.setDBVersion(version + 1) { error in
                    if let error { self.presenter.receivedError(error)
                    } else { self.presenter.showAlert() }
                }
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }
}
