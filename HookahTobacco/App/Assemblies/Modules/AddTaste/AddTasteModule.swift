//
//
//  AddTasteModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.11.2022.
//
//

import UIKit

struct AddTasteDataModule: DataModuleProtocol {
    let taste: Taste?
    let outputModule: AddTasteOutputModule?
}

class AddTasteModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = AddTasteDependency(appRouter: appRouter,
                                            taste: nil,
                                            outputModule: nil)
        if let data = data as? AddTasteDataModule {
            dependency.taste = data.taste
            dependency.outputModule = data.outputModule
        }
        return appRouter.resolver.resolve(AddTasteViewController.self, argument: dependency)
    }
}
