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
    func showAddManufacturer(_ data: Manufacturer, delegate: AddManufacturerOutputModule?)
    func showError(with message: String)
}

class ManufacturerListRouter: ManufacturerListRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showDetail(for manufacturer: Manufacturer) {
        let data = DetailInfoManufacturerDataModule(manufacturer: manufacturer)
        appRouter.pushViewController(module: DetailInfoManufacturerModule.self,
                                     moduleData: data,
                                     animateDisplay: true)
    }

    func showAddManufacturer(_ data: Manufacturer, delegate: AddManufacturerOutputModule?) {
        let data = AddManufacturerDataModule(editingManufacturer: data, delegate: delegate)
        appRouter.pushViewController(module: AddManufacturerModule.self,
                                     moduleData: data,
                                     animateDisplay: true)
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }
}
