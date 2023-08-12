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

protocol AdminMenuInteractorOutputProtocol: AnyObject {
    func receiveError(with message: String)
    func receiveSuccessLogout()
    func showAlert()
}

class AdminMenuInteractor {
    // MARK: - Public properties
    weak var presenter: AdminMenuInteractorOutputProtocol!

    // MARK: - Dependency
    private let authService: AuthServiceProtocol
    private let getDataManager: GetDataNetworkingServiceProtocol
    private let setDataManager: SetDataNetworkingServiceProtocol

    // MARK: - Private properties

    // MARK: - Initializers
    init(authService: AuthServiceProtocol,
         getDataManager: GetDataNetworkingServiceProtocol,
         setDataManager: SetDataNetworkingServiceProtocol) {
        self.authService = authService
        self.getDataManager = getDataManager
        self.setDataManager = setDataManager
    }
}

// MARK: - AdminMenuInteractorInputProtocol implementation
extension AdminMenuInteractor: AdminMenuInteractorInputProtocol {
    func logout() {
        authService.logout { [weak self] error in
            guard let self = self else { return }
            if let error {
                self.presenter.receiveError(with:
                    "Выйти из пользователя не вышло, причина: \(error.localizedDescription)")
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
                self.setDataManager.setDBVersion(version + 1) { error in
                    if let error = error { self.presenter.receiveError(with: error.localizedDescription)
                    } else { self.presenter.showAlert() }
                }
            case .failure(let error):
                self.presenter.receiveError(with: error.localizedDescription)
            }
        }
    }
}
