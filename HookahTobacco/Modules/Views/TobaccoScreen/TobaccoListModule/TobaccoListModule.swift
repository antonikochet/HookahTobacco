//
//
//  TobaccoListModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
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
            let moduleData = DetailTobaccoDataModule(tobacco: tobacco)
            appRouter.pushViewController(
                module: DetailTobaccoModule.self,
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
