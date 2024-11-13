//
//  TobaccoListModule.swift
//  HookahTobaccoAdmin
//
//  Created by Антон Кочетков on 13.11.2024.
//

import UIKit
import SwiftUI

struct TobaccoListDataModile: DataModuleProtocol {
    let filter: TobaccoListInput
}

class TobaccoListModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var input: TobaccoListInput = .none
        if let data = data as? TobaccoListDataModile {
            input = data.filter
        }
        let assembly = TobaccoListAssembly(
            filter: input
        ) { tobacco in
            let moduleData = AddTobaccoDataModule(editingTobacco: tobacco, delegate: nil)
            appRouter.pushViewController(
                module: AddTobaccoModule.self,
                moduleData: moduleData,
                animateDisplay: true
            )
        } showFilterTobacco: { (filters, delegate) in
            let moduleData = TobaccoFiltersDataModule(
                filters: filters,
                delegate: delegate
            )
            appRouter.presentViewModally(module: TobaccoFiltersModule.self, moduleData: moduleData)
        }

        return assembly.assemble(resolver: appRouter.resolver)
    }
}
