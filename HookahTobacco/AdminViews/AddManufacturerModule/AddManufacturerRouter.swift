//
//
//  AddManufacturerRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol AddManufacturerRouterProtocol: RouterProtocol {
    
}

class AddManufacturerRouter: AddManufacturerRouterProtocol {
    var appRouter: AppRouterProtocol
    weak var viewController: UIViewController!
    
    required init(_ appRouter: AppRouterProtocol, _ viewController: UIViewController) {
        self.appRouter = appRouter
        self.viewController = viewController
    }
}
