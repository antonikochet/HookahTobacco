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
    var router: AdminMenuRouterInputProtocol!
}

extension AdminMenuPresenter: AdminMenuInteractorOutputProtocol {
    func receiveError(with message: String) {
        view.showError(with: "Ошибка", and: message)
    }
    
    func receiveSuccessLogout() {
        router.showLoginModule()
    }
}

extension AdminMenuPresenter: AdminMenuViewOutputProtocol {
    func pressedAddManufacturerButton() {
        router.showAddManufacturerModule()
    }
    
    func pressedAddTobaccoButton() {
        router.showAddTobaccoModule()
    }
    
    func pressedLogoutButton() {
        interactor.logout()
    }
}
