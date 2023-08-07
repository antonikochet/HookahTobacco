//
//  RouterProtocol.swift
//  HookahTobacco
//
//  Created by антон кочетков on 10.10.2022.
//

import UIKit

protocol RouterProtocol: AnyObject {
    init(_ appRouter: AppRouterProtocol)
    var appRouter: AppRouterProtocol { get }
}

extension RouterProtocol {
    // MARK: - Error
    func showError(with message: String) {
        showError(with: message, completion: nil)
    }

    func showError(with message: String, completion: CompletionBlock?) {
        appRouter.presentAlert(type: .error(message: message), completion: completion)
    }

    // MARK: - Success alert
    func showSuccess(delay: Double) {
        appRouter.presentAlert(type: .success(delay: delay), completion: nil)
    }

    func showSuccess(delay: Double, with completion: CompletionBlock?) {
        appRouter.presentAlert(type: .success(delay: delay), completion: completion)
    }
}
