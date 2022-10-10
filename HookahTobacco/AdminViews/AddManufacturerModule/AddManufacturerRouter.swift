//
//
//  AddManufacturerRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 07.10.2022.
//
//

import UIKit

protocol AddManufacturerRouterProtocol: RouterProtocol {
    
}

class AddManufacturerRouter: AddManufacturerRouterProtocol {
    var appRouter: AppRouterProtocol
    
    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
}
