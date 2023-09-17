//
//
//  AddTastesModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.11.2022.
//
//

import UIKit
struct AddTastesDataModule: DataModuleProtocol {
    let selectedTastes: SelectedTastes
    let outputModule: AddTastesOutputModule?
}

class AddTastesModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {

        var dependency = AddTastesDependency(appRouter: appRouter,
                                             selectedTastes: [:],
                                             outputModule: nil)
        if let data = data as? AddTastesDataModule {
            dependency.selectedTastes = data.selectedTastes
            dependency.outputModule = data.outputModule
        }
        return appRouter.resolver.resolve(AddTastesViewController.self,
                                          argument: dependency)
    }
}
