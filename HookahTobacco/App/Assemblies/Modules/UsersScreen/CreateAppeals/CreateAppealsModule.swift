//
//
//  CreateAppealsModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import UIKit

class CreateAppealsModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let dependency = CreateAppealsDependency(appRouter: appRouter)
//        if let data = data as? CreateAppealsDataModule { }
        return appRouter.resolver.resolve(CreateAppealsViewController.self,
                                          argument: dependency)
    }
}
