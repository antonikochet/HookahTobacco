//
//
//  LoginRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol LoginRouterProtocol: RouterProtocol {
    func showProfileView()
    func showRegistrationView()
    func showError(with message: String)
}

class LoginRouter: LoginRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showProfileView() {
        appRouter.presentView(module: ProfileModule.self, moduleData: nil, animated: true)
    }

    func showRegistrationView() {
        appRouter.pushViewController(module: RegistrationModule.self, moduleData: nil, animateDisplay: true)
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }
}
