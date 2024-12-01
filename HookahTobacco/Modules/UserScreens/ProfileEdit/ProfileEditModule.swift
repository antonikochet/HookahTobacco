//
//
//  ProfileEditModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 13.08.2023.
//
//

import UIKit
import HookahTobaccoCore

struct ProfileEditDataModule: DataModuleProtocol {
    let isRegistration: Bool
    let user: RegistrationUser
    let output: ProfileEditOutputModule?
}

class ProfileEditModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        guard let data = data as? ProfileEditDataModule else {
            print("Не вышло преобразовать data к ProfileEditDataModule")
            return nil
        }
        let assembly = ProfileEditAssembly(isRegistration: data.isRegistration)
        return assembly.assemble(resolver: appRouter.resolver)
    }
}
