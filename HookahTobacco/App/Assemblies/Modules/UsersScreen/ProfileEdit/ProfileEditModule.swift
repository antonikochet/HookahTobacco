//
//
//  ProfileEditModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import UIKit

struct ProfileEditDataModule: DataModuleProtocol {
    let isRegistration: Bool
    let user: RegistrationUserProtocol
    let output: ProfileEditOutputModule?
}

class ProfileEditModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let dependency: ProfileEditDependency
        if let data = data as? ProfileEditDataModule {
            dependency = ProfileEditDependency(appRouter: appRouter,
                                               isRegistration: data.isRegistration,
                                               user: data.user,
                                               output: data.output)
        } else {
            fatalError("В модуль ProfileEditModule не был передан ProfileEditDataModule")
        }
        return appRouter.resolver.resolve(ProfileEditViewController.self,
                                          argument: dependency)
    }
}
