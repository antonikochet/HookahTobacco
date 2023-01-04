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
        let dependency = RegistrationDependency(appRouter: appRouter)
//        if let data = data as? RegistrationDataModule { }
        return appRouter.resolver.resolve(RegistrationViewController.self,
                                          argument: dependency)
    }
}
