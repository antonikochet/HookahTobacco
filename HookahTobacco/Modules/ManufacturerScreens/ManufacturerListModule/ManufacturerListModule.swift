//
//
//  ManufacturerListModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import UIKit

class ManufacturerListModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let assembly = ManufacturerListAssembly { manufacturer in
            let data = DetailInfoManufacturerDataModule(manufacturer: manufacturer)
            appRouter.pushViewController(
                module: DetailInfoManufacturerModule.self,
                moduleData: data,
                animateDisplay: true
            )
        }
        return assembly.assemble(resolver: appRouter.resolver)
    }
}
