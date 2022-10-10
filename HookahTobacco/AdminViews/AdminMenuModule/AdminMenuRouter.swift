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
    func showLoginModule()
}

class AdminMenuRouter: AdminMenuRouterProtocol {
    var appRouter: AppRouterProtocol
    weak var viewController: UIViewController!
    
    required init(_ appRouter: AppRouterProtocol, _ viewController: UIViewController) {
        self.appRouter = appRouter
        self.viewController = viewController
    }
    
    func showAddManufacturerModule() {
        appRouter.pushViewController(module: AddManufacturerModule.self, moduleData: nil, animateDisplay: true)
    }
    
    func showAddTobaccoModule() {
        appRouter.pushViewController(module: AddTobaccoModule.self, moduleData: nil, animateDisplay: true)
    }
    
    func showLoginModule() {
        appRouter.presentView(module: LoginModule.self, moduleData: nil, animated: true)
    }
}
