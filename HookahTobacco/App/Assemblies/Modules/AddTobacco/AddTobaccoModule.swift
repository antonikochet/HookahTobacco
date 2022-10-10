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
    
    static var nameModule: String {
        String(describing: self)
    }
    
    func createModule(_ appAssembler: AppAssemblerProtocol) -> UIViewController? {
        return appAssembler.resolver.resolve(AddTobaccoViewController.self, argument: appAssembler)
    }
}
