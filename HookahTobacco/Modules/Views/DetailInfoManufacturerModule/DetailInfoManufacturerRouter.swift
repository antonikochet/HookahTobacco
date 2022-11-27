//
//
//  DetailInfoManufacturerRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import UIKit

protocol DetailInfoManufacturerRouterProtocol: RouterProtocol {
    func showError(with message: String)
}

class DetailInfoManufacturerRouter: DetailInfoManufacturerRouterProtocol {
    private var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }
}
