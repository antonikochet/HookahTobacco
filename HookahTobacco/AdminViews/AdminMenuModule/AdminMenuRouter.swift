//
//
//  AdminMenuRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 08.10.2022.
//
//

import Foundation
import UIKit

protocol AdminMenuRouterInputProtocol {
    func showAddManufacturerModule()
    func showAddTobaccoModule()
    func showLoginModule()
}

class AdminMenuRouter: AdminMenuRouterInputProtocol {
    weak var viewController: AdminMenuViewController!
    
    func showAddManufacturerModule() {
        let configurator = AddManufacturerConfigurator(setNetworkManager: FireBaseSetNetworkManager())
        let vc = configurator.configure()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAddTobaccoModule() {
        let configurator = AddTobaccoConfigurator(getDataManager: FireBaseGetNetworkManager(),
                                                  setDataManager: FireBaseSetNetworkManager())
        let vc = configurator.configure()
        viewController.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showLoginModule() {
        let configurator = LoginConfigurator()
        let vc = configurator.configure()
        viewController.navigationController?.setViewControllers([vc], animated: true)
    }
}
