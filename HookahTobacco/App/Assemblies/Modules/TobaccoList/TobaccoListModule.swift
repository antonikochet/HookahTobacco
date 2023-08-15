//
//
//  TobaccoListModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import UIKit

struct TobaccoListDataModile: DataModuleProtocol {
    let isAdminMode: Bool
    let filter: TobaccoListInput
}

class TobaccoListModule: ModuleProtocol {
    private var data: DataModuleProtocol?

    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }

    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var dependency = TobaccoListDependency(appRouter: appRouter, isAdminMode: false, filter: .none)
        if let data = data as? TobaccoListDataModile {
            dependency.isAdminMode = data.isAdminMode
            dependency.filter = data.filter
        }
        return appRouter.resolver.resolve(TobaccoListViewController.self, argument: dependency)
    }
}
