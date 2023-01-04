//
//
//  RegistrationRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//
//

import UIKit

protocol RegistrationRouterProtocol: RouterProtocol {
    func showError(_ message: String)
    func showProfileRegistrationView()
}

final class RegistrationRouter: RegistrationRouterProtocol {
    // MARK: - Private properties
    private let appRouter: AppRouterProtocol

    init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showError(_ message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }

    func showProfileRegistrationView() {
        print("show profile registration view")
    }
}
