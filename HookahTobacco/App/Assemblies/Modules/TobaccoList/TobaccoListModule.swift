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
}

class TobaccoListModule: ModuleProtocol {
    private var data: DataModuleProtocol?
    
    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }
    
    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var isAdminMode = false
        if let data = data as? TobaccoListDataModile {
            isAdminMode = data.isAdminMode
        }
        return appRouter.resolver.resolve(TobaccoListViewController.self, arguments: appRouter, isAdminMode)
    }
}
