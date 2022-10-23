//
//
//  ManufacturerListModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import UIKit

struct ManufacturerListDataModile: DataModuleProtocol {
    let isAdminMode: Bool
}

class ManufacturerListModule: ModuleProtocol {
    private var data: DataModuleProtocol?
    
    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }
    
    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        var isAdminMode = false
        if let data = data as? ManufacturerListDataModile {
            isAdminMode = data.isAdminMode
        }
        return appRouter.resolver.resolve(ManufacturerListViewController.self, arguments: appRouter, isAdminMode)
    }
}
