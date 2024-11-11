//
//
//  RegistrationRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 18.12.2022.
//
//

import UIKit
import HookahTobaccoCore

protocol RegistrationRouterProtocol: RouterProtocol {
    func showProfileRegistrationView(user: RegistrationUser)
}

final class RegistrationRouter: RegistrationRouterProtocol {
    var appRouter: AppRouterProtocol

    init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showProfileRegistrationView(user: RegistrationUser) {
        let data = ProfileEditDataModule(isRegistration: true, user: user, output: nil)
        appRouter.pushViewController(module: ProfileEditModule.self, moduleData: data, animateDisplay: true)
    }
}
