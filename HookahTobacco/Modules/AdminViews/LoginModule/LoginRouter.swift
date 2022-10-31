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
    
    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
    
    func presentAddMenuView() {
        appRouter.presentView(module: AdminMenuModule.self, moduleData: nil, animated: true)
    }
}
