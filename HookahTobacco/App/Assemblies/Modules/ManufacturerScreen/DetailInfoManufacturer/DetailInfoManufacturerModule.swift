//
//
//  DetailInfoManufacturerModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.11.2022.
//
//

import UIKit

struct DetailInfoManufacturerDataModule: DataModuleProtocol {
    let manufacturer: Manufacturer
}

class DetailInfoManufacturerModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        if let data = data as? DetailInfoManufacturerDataModule {
            let dependency = DetailInfoManufacturerDependency(appRouter: appRouter,
                                                              manufacturer: data.manufacturer)
            return appRouter.resolver.resolve(DetailInfoManufacturerViewController.self,
                                              argument: dependency)
        }
        print("В модуль DetailInfoManufacturerModule не были переданны данные необходимые для показа модуля")
        return nil
    }
}
