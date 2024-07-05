//
//  LoginRouter.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 05.07.2024.
//

import UIKit

protocol LoginRouterProtocol: RouterProtocol {
    func showProfileView()
    func showRegistrationView()
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
    }
}
