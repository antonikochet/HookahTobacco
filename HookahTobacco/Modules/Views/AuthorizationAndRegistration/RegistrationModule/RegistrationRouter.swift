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
    func showProfileRegistrationView(user: RegistrationUserProtocol)
}

final class RegistrationRouter: RegistrationRouterProtocol {
    var appRouter: AppRouterProtocol

    init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showProfileRegistrationView(user: RegistrationUserProtocol) {
        let data = ProfileEditDataModule(isRegistration: true, user: user, output: nil)
        appRouter.pushViewController(module: ProfileEditModule.self, moduleData: data, animateDisplay: true)
    }
}
