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
    func openDetailTobacco(_ tobacco: Tobacco)
}

class DetailInfoManufacturerRouter: DetailInfoManufacturerRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func openDetailTobacco(_ tobacco: Tobacco) {
        let data = DetailTobaccoDataModule(tobacco: tobacco)
        appRouter.pushViewController(module: DetailTobaccoModule.self, moduleData: data, animateDisplay: true)
    }
}
