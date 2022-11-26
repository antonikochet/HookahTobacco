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
    func receiveError(with message: String) {
        view.showError(with: "Ошибка", and: message)
    }

    func receiveSuccessLogout() {
        router.showLoginModule()
    }

    func showAlert() {
        router.showAlert()
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

    func pressedLogoutButton() {
        interactor.logout()
    }
}
