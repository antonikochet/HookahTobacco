//
//
//  TobaccoFiltersModule.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 29.08.2023.
//
//

import UIKit

struct TobaccoFiltersDataModule: DataModuleProtocol {
    let filters: TobaccoFilters?
    let delegate: TobaccoFiltersOutputModule?
}

class TobaccoFiltersModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = TobaccoFiltersDependency(appRouter: appRouter)
        if let data = data as? TobaccoFiltersDataModule {
            dependency.filters = data.filters
            dependency.delegate = data.delegate
        }
        return appRouter.resolver.resolve(TobaccoFiltersViewController.self,
                                          argument: dependency)
    }
}
