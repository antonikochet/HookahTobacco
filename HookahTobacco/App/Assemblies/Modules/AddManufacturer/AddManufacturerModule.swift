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
    var delegate: AddManufacturerOutputModule? = nil
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
        var manufacturer: Manufacturer? = nil
        var delegate: AddManufacturerOutputModule? = nil
        if let data = data as? AddManufacturerDataModule {
            manufacturer = data.editingManufacturer
            delegate = data.delegate
        }
        return appRouter.resolver.resolve(AddManufacturerViewController.self, arguments: appRouter, manufacturer, delegate)
    }
}
