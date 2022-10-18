//
//
//  ManufacturerListRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 13.10.2022.
//
//

import UIKit

protocol ManufacturerListRouterProtocol: RouterProtocol {
    func showDetail(for manufacturer: Manufacturer)
}

class ManufacturerListRouter: ManufacturerListRouterProtocol {
    var appRouter: AppRouterProtocol
    
    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
    
    func showDetail(for manufacturer: Manufacturer) {
        print(#function, manufacturer)
        //TODO: create a detailed view of the manufacturer and create a transition to the detailed view
    }
}
