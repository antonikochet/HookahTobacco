//
//  AddTobaccoModule.swift
//  HookahTobaccoAdmin
//
//  Created by антон кочетков on 09.10.2022.
//

import UIKit
import HookahTobaccoCore

struct AddTobaccoDataModule: DataModuleProtocol {
    let editingTobacco: Tobacco
    let delegate: AddTobaccoOutputModule?
}

class AddTobaccoModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = AddTobaccoDependency(appRouter: appRouter)
        if let data = data as? AddTobaccoDataModule {
            dependency.tobacco = data.editingTobacco
            dependency.delegate = data.delegate
        }
        return appRouter.resolver.resolve(AddTobaccoViewController.self, argument: dependency)
    }
}
