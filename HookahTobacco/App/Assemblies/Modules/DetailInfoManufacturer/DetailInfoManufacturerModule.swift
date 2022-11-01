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
            return appRouter.resolver.resolve(DetailInfoManufacturerViewController.self,
                                              arguments: appRouter,
                                              data.manufacturer)
        }
        print("В модуль DetailInfoManufacturerModule не были переданны данные необходимые для показа модуля")
        return nil
    }
}
