//
//
//  AddTobaccoLineModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.08.2023.
//
//

import UIKit

struct AddTobaccoLineDataModule: DataModuleProtocol {
    let manufacturerId: Int
    let editingTobaccoLine: TobaccoLine?
    let delegate: AddTobaccoLineOutputModule?
}

class AddTobaccoLineModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = AddTobaccoLineDependency(appRouter: appRouter, manufacturerId: 0)
        if let data = data as? AddTobaccoLineDataModule {
            dependency.manufacturerId = data.manufacturerId
            dependency.tobaccoLine = data.editingTobaccoLine
            dependency.delegate = data.delegate
        } else {
            fatalError("AddTobaccoLineDataModule was not received when creating the module")
        }
        return appRouter.resolver.resolve(AddTobaccoLineViewController.self,
                                          argument: dependency)
    }
}
