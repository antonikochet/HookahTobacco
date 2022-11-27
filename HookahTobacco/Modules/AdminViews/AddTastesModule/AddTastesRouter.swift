//
//
//  AddTastesRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 12.11.2022.
//
//

import UIKit

protocol AddTastesRouterProtocol: RouterProtocol {
    func showAddTaste(taste: Taste?, allIdsTaste: Set<Int>, outputModule: AddTasteOutputModule)
    func dismissView(newSelectedTastes: [Taste])
    func showError(with message: String)
}

protocol AddTastesOutputModule: AnyObject {
    func sendSelectedTastes(_ tastes: [Taste])
}

class AddTastesRouter: AddTastesRouterProtocol {
    private var appRouter: AppRouterProtocol
    weak var outputModule: AddTastesOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showAddTaste(taste: Taste?, allIdsTaste: Set<Int>, outputModule: AddTasteOutputModule) {
        let data = AddTasteDataModule(taste: taste,
                                      allIdsTaste: allIdsTaste,
                                      outputModule: outputModule)
        appRouter.presentViewModally(module: AddTasteModule.self, moduleData: data)
    }

    func dismissView(newSelectedTastes: [Taste]) {
        appRouter.popViewConroller(animated: true, completion: nil)
        outputModule?.sendSelectedTastes(newSelectedTastes)
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }
}
