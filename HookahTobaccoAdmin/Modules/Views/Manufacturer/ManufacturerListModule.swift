//
//  ManufacturerListModule.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 12.11.2024.
//

import UIKit

class ManufacturerListModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        let assembly = ManufacturerListAssembly { manufacturer in
            let data = AddManufacturerDataModule(editingManufacturer: manufacturer)
            appRouter.pushViewController(
                module: AddManufacturerModule.self,
                moduleData: data,
                animateDisplay: true
            )
        }
        return assembly.assemble(resolver: appRouter.resolver)
    }
}
