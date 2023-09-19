//
//
//  AdminMenuPresenter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.10.2022.
//
//

import Foundation

class AdminMenuPresenter {
    weak var view: AdminMenuViewInputProtocol!
    var interactor: AdminMenuInteractorInputProtocol!
    var router: AdminMenuRouterProtocol!
}

// MARK: - AdminMenuInteractorOutputProtocol implementation
extension AdminMenuPresenter: AdminMenuInteractorOutputProtocol {
    func receivedError(_ error: HTError) {
        router.showError(with: error.message)
    }

    func receiveSuccessLogout() {
        router.showLoginModule()
    }

    func showAlert() {
        router.showSuccess(delay: 2.0)
    }
}

// MARK: - AdminMenuViewOutputProtocol implementation
extension AdminMenuPresenter: AdminMenuViewOutputProtocol {
    func pressedAddManufacturerButton() {
        router.showAddManufacturerModule()
    }

    func pressedAddTobaccoButton() {
        router.showAddTobaccoModule()
    }

    func pressedEditManufacturers() {
        router.showManufacturerListModule()
    }

    func pressedEditTobacco() {
        router.showTobaccoListModule()
    }

    func pressedUpgradeBDVersion() {
        interactor.upgradeDBVersion()
    }

    func pressedEditAppeals() {
        router.showAppealsListModule()
    }

    func pressedLogoutButton() {
        interactor.logout()
    }
}
