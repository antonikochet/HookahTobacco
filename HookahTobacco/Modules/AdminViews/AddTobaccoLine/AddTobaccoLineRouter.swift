//
//
//  AddTobaccoLineRouter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 04.08.2023.
//
//

import UIKit

protocol AddTobaccoLineRouterProtocol: RouterProtocol {
    func showSuccess(with completion: (() -> Void)?)
    func showError(with message: String)
    func dismissView()
    func dismissView(with tobaccoLine: TobaccoLine)
}

protocol AddTobaccoLineOutputModule: AnyObject {
    func send(_ tobaccoLine: TobaccoLine?)
}

class AddTobaccoLineRouter: AddTobaccoLineRouterProtocol {
    // MARK: - Private properties
    private let appRouter: AppRouterProtocol
    weak var delegate: AddTobaccoLineOutputModule?
    
    required init(_ appRouter: AppRouterProtocol) {
        self.appRouter = appRouter
    }

    func showSuccess(with completion: (() -> Void)?) {
        appRouter.presentAlert(type: .success(delay: 3.0), completion: completion)
    }
    
    func showError(with message: String) {
        appRouter.presentAlert(type: .error(message: message), completion: nil)
    }

    func dismissView() {
        delegate?.send(nil)
        appRouter.dismissView(animated: true, completion: nil)
    }

    func dismissView(with tobaccoLine: TobaccoLine) {
        delegate?.send(tobaccoLine)
        appRouter.dismissView(animated: true, completion: nil)
    }
}
