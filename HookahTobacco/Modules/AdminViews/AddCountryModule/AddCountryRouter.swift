//
//
//  AddCountryRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import UIKit

protocol AddCountryRouterProtocol: RouterProtocol {
    func showError(with message: String)
    func showSuccess(delay: Double)
}

protocol AddCountryOutputModule: AnyObject {
    func send(_ countries: [Country])
}

class AddCountryRouter: AddCountryRouterProtocol {
    // MARK: - Private properties
    private let appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }

    func showSuccess(delay: Double) {
        appRouter.presentAlert(type: .success(delay: delay), completion: nil)
    }
}
