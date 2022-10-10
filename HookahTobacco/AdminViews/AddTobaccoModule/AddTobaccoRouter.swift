//
//
//  AddTobaccoRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol AddTobaccoRouterInputProtocol: RouterProtocol {
    
}

class AddTobaccoRouter: AddTobaccoRouterInputProtocol {
    var appAssembler: AppAssemblerProtocol
    weak var viewController: UIViewController!
    
    required init(_ appAssembler: AppAssemblerProtocol, _ viewController: UIViewController) {
        self.appAssembler = appAssembler
        self.viewController = viewController
    }
}
