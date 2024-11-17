//
//
//  RegistrationModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 28.12.2022.
//
//

import UIKit

class RegistrationModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let assembly = RegistrationAssembly { user in
            let data = ProfileEditDataModule(isRegistration: true, user: user, output: nil)
            appRouter.pushViewController(module: ProfileEditModule.self, moduleData: data, animateDisplay: true)
        }
        return assembly.assemble(resolver: appRouter.resolver)
    }
}
