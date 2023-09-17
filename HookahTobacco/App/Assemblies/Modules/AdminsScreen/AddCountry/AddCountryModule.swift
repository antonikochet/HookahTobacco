//
//
//  AddCountryModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 06.08.2023.
//
//

import UIKit

struct AddCountryDataModule: DataModuleProtocol {
    let delegate: AddCountryOutputModule?
}

class AddCountryModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = AddCountryDependency(appRouter: appRouter)
        if let data = data as? AddCountryDataModule {
            dependency.delegate = data.delegate
        }
        return appRouter.resolver.resolve(AddCountryViewController.self,
                                          argument: dependency)
    }
}
