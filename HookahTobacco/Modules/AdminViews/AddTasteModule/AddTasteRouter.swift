//
//
//  AddTasteRouter.swift
//  HookahTobacco
//
//  Created by антон кочетков on 15.11.2022.
//
//

import UIKit

protocol AddTasteRouterProtocol: RouterProtocol {
    func dismissView(_ newTaste: Taste)
    func showError(with message: String)
    func showSuccess(delay: Double, with completion: CompletionBlock?)
}

protocol AddTasteOutputModule: AnyObject {
    func sendTaste(_ taste: Taste)
}

class AddTasteRouter: AddTasteRouterProtocol {
    private var appRouter: AppRouterProtocol
    weak var outputModule: AddTasteOutputModule?

    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func dismissView(_ newTaste: Taste) {
        appRouter.dismissView(animated: true) {
            self.outputModule?.sendTaste(newTaste)
        }
    }

    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }

    func showSuccess(delay: Double, with completion: CompletionBlock?) {
        appRouter.presentAlert(type: .success(delay: delay), completion: completion)
    }
}
