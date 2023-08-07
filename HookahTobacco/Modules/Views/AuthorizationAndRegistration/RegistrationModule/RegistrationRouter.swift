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
    func showProfileRegistrationView()
}

final class RegistrationRouter: RegistrationRouterProtocol {
    var appRouter: AppRouterProtocol

    init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showProfileRegistrationView() {
        print("show profile registration view")
    }
}
