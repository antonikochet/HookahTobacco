//
//
//  AddManufacturerModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import UIKit

struct AddManufacturerDataModule: DataModuleProtocol {
    let editingManufacturer: Manufacturer
    var delegate: AddManufacturerOutputModule?
}

class AddManufacturerModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    static var nameModule: String {
        String(describing: self)
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = AddManufacturerDependency(appRouter: appRouter,
                                                   manufacturer: nil,
                                                   delegate: nil)
        if let data = data as? AddManufacturerDataModule {
            dependency.manufacturer = data.editingManufacturer
            dependency.delegate = data.delegate
        }
        return appRouter.resolver.resolve(AddManufacturerViewController.self, argument: dependency)
    }
}
