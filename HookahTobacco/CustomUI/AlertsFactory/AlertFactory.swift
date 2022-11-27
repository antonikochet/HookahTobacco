//
//  AlertFactory.swift
//  HookahTobacco
//
//  Created by антон кочетков on 27.11.2022.
//

import UIKit

struct AlertFactory {

    enum AlertType {
        case success(delay: Double)
        case error(message: String)
    }

    // MARK: - singleton
    static let shared: AlertFactory = AlertFactory()

    private init() {}

    // MARK: - Public methods
    func showAlert(_ type: AlertType,
                   from viewController: UIViewController,
                   completion: (() -> Void)? = nil) {
        switch type {
        case .success(let delay):
            showSuccessAlert(.success, delay: delay, from: viewController)
        case .error(let message):
            showErrorAlert(with: message, from: viewController)
        }
    }

    // MARK: - Private methods
    private func showErrorAlert(with message: String,
                                from viewController: UIViewController,
                                completion: (() -> Void)? = nil) {
        let alertVC = UIAlertController(title: "Ошибка",
                                        message: message,
                                        preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        }
        alertVC.addAction(okAction)

        viewController.present(alertVC, animated: true)
    }

    private func showSuccessAlert(_ type: PopupAlertView.AlertType,
                                  delay: Double,
                                  from viewController: UIViewController) {
        let alert = PopupAlertView.createView(superview: viewController.view)
        switch type {
        case .success:
            alert.show(type, delay: delay)
        case .error:
            alert.show(type, delay: delay)
        }
    }
}
