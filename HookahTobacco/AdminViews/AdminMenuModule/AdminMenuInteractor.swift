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
}

protocol AdminMenuInteractorOutputProtocol: AnyObject {
    func receiveError(with message: String)
    func receiveSuccessLogout()
}

class AdminMenuInteractor {
    weak var presenter: AdminMenuInteractorOutputProtocol!
}

extension AdminMenuInteractor: AdminMenuInteractorInputProtocol {
    func logout() {
        FireBaseAuthService.shared.logout { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                let nserror = error as NSError
                self.presenter.receiveError(with: "Выйти из пользователя не вышло, причина: \(nserror.userInfo)")
            } else {
                self.presenter.receiveSuccessLogout()
            }
        }
    }
}
