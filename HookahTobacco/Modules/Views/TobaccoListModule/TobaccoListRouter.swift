//
//
//  TobaccoListRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 26.10.2022.
//
//

import UIKit

protocol TobaccoListRouterProtocol: RouterProtocol {
    func showDetail(for data: Tobacco)
    func showAddTobacco(_ data: Tobacco, delegate: AddTobaccoOutputModule?)
    func showMessage(with message: String)
}

class TobaccoListRouter: TobaccoListRouterProtocol {
    var appRouter: AppRouterProtocol

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showDetail(for data: Tobacco) {
        let tData = DetailTobaccoDataModule(tobacco: data)
        appRouter.pushViewController(module: DetailTobaccoModule.self,
                                     moduleData: tData,
                                     animateDisplay: true)
    }

    func showAddTobacco(_ data: Tobacco, delegate: AddTobaccoOutputModule?) {
        let tData = AddTobaccoDataModule(editingTobacco: data, delegate: delegate)
        appRouter.pushViewController(module: AddTobaccoModule.self,
                                     moduleData: tData,
                                     animateDisplay: true)
    }

    func showMessage(with message: String) {
        appRouter.presentAlert(type: .systemSuccess(message: message, delay: 5), completion: nil)
    }
}
