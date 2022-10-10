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
    var appAssembler: AppRouterProtocol
    weak var viewController: UIViewController!
    
    required init(_ appAssembler: AppRouterProtocol, _ viewController: UIViewController) {
        self.appAssembler = appAssembler
        self.viewController = viewController
    }
    
    func showAddManufacturerModule() {
        let configurator = AddManufacturerConfigurator(setNetworkManager: FireBaseSetNetworkManager())
        let vc = configurator.configure()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAddTobaccoModule() {
        appAssembler.pushViewController(module: AddTobaccoModule.self, moduleData: nil, animateDisplay: true)
    }
    
    func showLoginModule() {
        let configurator = LoginConfigurator()
        let vc = configurator.configure()
        viewController.navigationController?.setViewControllers([vc], animated: true)
    }
}
