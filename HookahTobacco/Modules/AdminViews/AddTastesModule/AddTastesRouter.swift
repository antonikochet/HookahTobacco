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
    func showAddTaste(taste: Taste?, outputModule: AddTasteOutputModule)
    func dismissView(newSelectedTastes: [Taste])
}

protocol AddTastesOutputModule: AnyObject {
    func sendSelectedTastes(_ tastes: [Taste])
}

class AddTastesRouter: AddTastesRouterProtocol {
    var appRouter: AppRouterProtocol
    weak var outputModule: AddTastesOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showAddTaste(taste: Taste?, outputModule: AddTasteOutputModule) {
        let data = AddTasteDataModule(taste: taste,
                                      outputModule: outputModule)
        appRouter.presentViewModally(module: AddTasteModule.self, moduleData: data)
    }

    func dismissView(newSelectedTastes: [Taste]) {
        appRouter.popViewConroller(animated: true, completion: nil)
        outputModule?.sendSelectedTastes(newSelectedTastes)
    }
}
