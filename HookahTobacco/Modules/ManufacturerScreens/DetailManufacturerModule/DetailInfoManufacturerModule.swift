//
//
//  DetailInfoManufacturerModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 01.11.2022.
//
//

import UIKit
import HookahTobaccoCore

struct DetailInfoManufacturerDataModule: DataModuleProtocol {
    let manufacturer: Manufacturer
}

class DetailInfoManufacturerModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        guard let data = data as? DetailInfoManufacturerDataModule else {
            print("В модуль DetailInfoManufacturerModule не были переданны данные необходимые для показа модуля")
            return nil
        }
        
        let assembly = DetailManufacturerAssembly(manufacturer: data.manufacturer) { tobacco in
            let moduleData = DetailTobaccoDataModule(tobacco: tobacco)
            appRouter.pushViewController(
                module: DetailTobaccoModule.self,
                moduleData: moduleData,
                animateDisplay: true
            )
        }
        return assembly.assemble(resolver: appRouter.resolver)
    }
}
