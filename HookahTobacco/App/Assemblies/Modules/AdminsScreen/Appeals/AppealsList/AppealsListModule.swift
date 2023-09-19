//
//
//  AppealsListModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import UIKit

class AppealsListModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let dependency = AppealsListDependency(appRouter: appRouter)
//        if let data = data as? AppealsListDataModule { }
        return appRouter.resolver.resolve(AppealsListViewController.self,
                                          argument: dependency)
    }
}
