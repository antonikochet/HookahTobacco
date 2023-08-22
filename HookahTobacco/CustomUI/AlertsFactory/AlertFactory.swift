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
        case toastSuccess(title: String? = nil,
                          message: String,
                          delay: Double,
                          position: ToastView.PositionView,
                          isShowIcon: Bool = false)
        case toastError(title: String? = nil,
                        message: String,
                        delay: Double,
                        position: ToastView.PositionView)
    }

    // MARK: - singleton
    static let shared: AlertFactory = AlertFactory()

    private init() {}

    // MARK: - Public methods
    func showAlert(_ type: AlertType,
                   from viewController: UIViewController,
                   completion: CompletionBlock? = nil) {
        switch type {
        case .success(let delay):
            showSuccessAlert(.success, delay: delay, from: viewController, completion: completion)
        case .error(let message):
            showErrorAlert(with: message, from: viewController, completion: completion)
        case let .toastSuccess(title, message, delay, position, isShowIcon):
            showToast(title: title,
                      message: message,
                      delay: delay,
                      position: position,
                      isShowIcon: isShowIcon,
                      from: viewController)
            completion?()
        case let .toastError(title, message, delay, position):
            showErrorToast(title: title,
                           message: message,
                           delay: delay,
                           position: position,
                           from: viewController)
            completion?()
        }
    }

    // MARK: - Private methods
    private func showErrorAlert(with message: String,
                                from viewController: UIViewController,
                                completion: CompletionBlock? = nil) {
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
                                  from viewController: UIViewController,
                                  completion: CompletionBlock? = nil) {
        let alert = PopupAlertView.createView(superview: viewController.view)
        alert.show(type, delay: delay, completion: completion)
    }
    // swiftlint: disable:next function_parameter_count
    private func showToast(title: String?,
                           message: String,
                           delay: Double,
                           position: ToastView.PositionView,
                           isShowIcon: Bool,
                           from viewController: UIViewController) {
        let toastView = ToastView.createView(superview: viewController.view)
        toastView.positionViewOnSuperView = position
        toastView.showToast(title: title, message: message, delay: delay, isShowIcon: isShowIcon)
    }

    private func showErrorToast(title: String?,
                                message: String,
                                delay: Double,
                                position: ToastView.PositionView,
                                from viewController: UIViewController) {
        let toastView = ToastView.createView(superview: viewController.view)
        toastView.positionViewOnSuperView = position
        toastView.showErrorToast(title: title, message: message, delay: delay)
    }
}
