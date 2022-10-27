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
}

class TobaccoListRouter: TobaccoListRouterProtocol {
    var appRouter: AppRouterProtocol
    
    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }
    
    func showDetail(for data: Tobacco) {
        
    }
    
    func showAddTobacco(_ data: Tobacco, delegate: AddTobaccoOutputModule?) {
        let tData = AddTobaccoDataModule(editingTobacco: data, delegate: delegate)
        appRouter.presentView(module: AddTobaccoModule.self,
                              moduleData: tData,
                              animated: true)
    }
}
