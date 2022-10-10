//
//  AddTobaccoModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.10.2022.
//

import UIKit

class AddTobaccoModule: ModuleProtocol {
    private var data: DataModuleProtocol?
    
    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }
    
    func createModule(_ appAssembler: AppRouterProtocol) -> UIViewController? {
        return appAssembler.resolver.resolve(AddTobaccoViewController.self, argument: appAssembler)
    }
}
