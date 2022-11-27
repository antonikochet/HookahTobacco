//
//
//  LoginModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import UIKit

class LoginModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let dependency = LoginDependency(appRouter: appRouter)
        return appRouter.resolver.resolve(LoginViewController.self, argument: dependency)
    }
}
