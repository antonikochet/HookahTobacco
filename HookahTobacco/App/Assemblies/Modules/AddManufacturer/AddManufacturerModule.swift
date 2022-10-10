//
//
//  AddManufacturerModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//
//

import UIKit

class AddManufacturerModule: ModuleProtocol {
    private var data: DataModuleProtocol?
    
    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }
    
    static var nameModule: String {
        String(describing: self)
    }
    
    func createModule(_ appRouter: AppRouterProtocol) -> UIViewController? {
        return appRouter.resolver.resolve(AddManufacturerViewController.self, argument: appRouter)
    }
}
