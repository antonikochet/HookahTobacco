//
//
//  ProfileModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 05.01.2023.
//
//

import UIKit

class ProfileModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let dependency = ProfileDependency(appRouter: appRouter)
//        if let data = data as? ProfileDataModule { }
        return appRouter.resolver.resolve(ProfileViewController.self,
                                          argument: dependency)
    }
}
