//
//
//  AddTobaccoRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol AddTobaccoRouterProtocol: RouterProtocol {
    
}

class AddTobaccoRouter: AddTobaccoRouterProtocol {
    var appAssembler: AppRouterProtocol
    weak var viewController: UIViewController!
    
    required init(_ appAssembler: AppRouterProtocol, _ viewController: UIViewController) {
        self.appAssembler = appAssembler
        self.viewController = viewController
    }
}
