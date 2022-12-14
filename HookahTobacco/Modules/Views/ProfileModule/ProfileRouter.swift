//
//
//  ProfileRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 04.01.2023.
//
//

import UIKit

protocol ProfileRouterProtocol: RouterProtocol {
    func showError(with message: String)
    func showAdminMenu()
    func showRegistrationView()
    func showLoginView()
}

final class ProfileRouter: ProfileRouterProtocol {
    // MARK: - Private properties
    private let appRouter: AppRouterProtocol

    init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }

    func showAdminMenu() {
        appRouter.pushViewController(module: AdminMenuModule.self, moduleData: nil, animateDisplay: true)
    }

    func showRegistrationView() {
        appRouter.pushViewController(module: RegistrationModule.self, moduleData: nil, animateDisplay: true)
    }

    func showLoginView() {
        appRouter.presentView(module: LoginModule.self, moduleData: nil, animated: true)
    }
}
