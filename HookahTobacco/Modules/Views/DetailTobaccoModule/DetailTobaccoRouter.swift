//
//
//  DetailTobaccoRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 25.11.2022.
//
//

import UIKit

protocol DetailTobaccoRouterProtocol: RouterProtocol {
    func showError(with message: String)
}

class DetailTobaccoRouter: DetailTobaccoRouterProtocol {
    private let appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }
}
