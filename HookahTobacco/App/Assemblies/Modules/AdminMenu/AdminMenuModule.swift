//
//
//  AdminMenuModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import UIKit

class AdminMenuModule: ModuleProtocol {
    private var data: DataModuleProtocol?
    
    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }
    
    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        return appRouter.resolver.resolve(AdminMenuViewController.self, argument: appRouter)
    }
}
