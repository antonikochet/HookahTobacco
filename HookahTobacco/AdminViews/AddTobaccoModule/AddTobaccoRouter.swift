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
    var appRouter: AppRouterProtocol
    
    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
}
