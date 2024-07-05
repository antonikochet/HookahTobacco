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
    func dismissView()
    func dismissView(with changedData: Tobacco)
    func showAddTastesView(_ tastes: SelectedTastes, outputModule: AddTastesOutputModule?)
}

protocol AddTobaccoOutputModule: AnyObject {
    func sendChangedTobacco(_ tobacco: Tobacco)
}

class AddTobaccoRouter: AddTobaccoRouterProtocol {
    var appRouter: AppRouterProtocol
    weak var delegate: AddTobaccoOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func dismissView() {
        appRouter.popViewConroller(animated: true, completion: nil)
    }

    func dismissView(with changedData: Tobacco) {
        delegate?.sendChangedTobacco(changedData)
        appRouter.popViewConroller(animated: true, completion: nil)
    }

    func showAddTastesView(_ tastes: SelectedTastes, outputModule: AddTastesOutputModule?) {
        let data = AddTastesDataModule(selectedTastes: tastes,
                                       outputModule: outputModule)
        appRouter.pushViewController(module: AddTastesModule.self,
                                     moduleData: data,
                                     animateDisplay: true)
    }
}
