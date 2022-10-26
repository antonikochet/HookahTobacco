//
//  AddTobaccoModule.swift
//  HookahTobacco
//
//  Created by антон кочетков on 09.10.2022.
//

import UIKit

struct AddTobaccoDataModule: DataModuleProtocol {
    let editingTobacco: Tobacco
    let delegate: AddTobaccoOutputModule?
}

class AddTobaccoModule: ModuleProtocol {
    private var data: DataModuleProtocol?
    
    required init(_ data: DataModuleProtocol? = nil) {
        self.data = data
    }
    
    func createModule(_ appAssembler: AppRouterProtocol) -> UIViewController? {
        var tobacco: Tobacco? = nil
        var delegate: AddTobaccoOutputModule? = nil
        if let data = data as? AddTobaccoDataModule {
            tobacco = data.editingTobacco
            delegate = data.delegate
        }
        return appAssembler.resolver.resolve(AddTobaccoViewController.self, arguments: appAssembler, tobacco, delegate)
    }
}
