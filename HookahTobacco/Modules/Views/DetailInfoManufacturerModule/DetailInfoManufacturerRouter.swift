//
//
//  DetailInfoManufacturerRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 31.10.2022.
//
//

import UIKit

protocol DetailInfoManufacturerRouterProtocol: RouterProtocol {

}

class DetailInfoManufacturerRouter: DetailInfoManufacturerRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
}
