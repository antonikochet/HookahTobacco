//
//
//  LoginRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol LoginRouterProtocol: RouterProtocol {
    func presentAddMenuView()
}

class LoginRouter: LoginRouterProtocol {
    var appRouter: AppRouterProtocol
    weak var viewController: UIViewController!
    
    required init(_ appRouter: AppRouterProtocol, _ viewController: UIViewController) {
        self.appRouter = appRouter
        self.viewController = viewController
    }
    
    func presentAddMenuView() {
        appRouter.presentView(module: AdminMenuModule.self, moduleData: nil, animated: true)
    }
}
