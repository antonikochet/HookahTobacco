//
//
//  AdminMenuRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.10.2022.
//
//

import UIKit

protocol AdminMenuRouterProtocol: RouterProtocol {
    func showAddManufacturerModule()
    func showAddTobaccoModule()
    func showManufacturerListModule()
    func showTobaccoListModule()
    func showLoginModule()
}

class AdminMenuRouter: AdminMenuRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showAddManufacturerModule() {
        appRouter.pushViewController(module: AddManufacturerModule.self, moduleData: nil, animateDisplay: true)
    }

    func showAddTobaccoModule() {
        appRouter.pushViewController(module: AddTobaccoModule.self, moduleData: nil, animateDisplay: true)
    }

    func showManufacturerListModule() {
        let data = ManufacturerListDataModile(isAdminMode: true)
        appRouter.pushViewController(module: ManufacturerListModule.self, moduleData: data, animateDisplay: true)
    }

    func showTobaccoListModule() {
        let data = TobaccoListDataModile(isAdminMode: true, filter: .none)
        appRouter.pushViewController(module: TobaccoListModule.self, moduleData: data, animateDisplay: true)
    }

    func showLoginModule() {
        appRouter.presentView(module: LoginModule.self, moduleData: nil, animated: true)
    }
}
