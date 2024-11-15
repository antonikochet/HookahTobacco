//
//
//  LoginModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import UIKit

final class LoginModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let assembly = LoginAssembly {
            appRouter.presentView(module: ProfileModule.self, moduleData: nil, animated: true)
        } showRegistration: {
            appRouter.pushViewController(module: RegistrationModule.self, moduleData: nil, animateDisplay: true)
        }
        return assembly.assemble(resolver: appRouter.resolver)
    }
}
