//
//  ViewProtocol.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 07.08.2023.
//

import UIKit

protocol ViewProtocol: AnyObject {
    func showLoading()
    func showBlockLoading()
    func hideLoading()
    func showErrorView(title: String, message: String, image: UIImage?,
                       refreshButtonTitle: String, buttonAction: CompletionBlock?)
    func hideErrorView()
    func showInfoView(viewModel: InfoViewModel)
    func hideInfoView()
}

extension ViewProtocol {
    func showErrorView(title: String, message: String, image: UIImage?, buttonAction: CompletionBlock?) {
        showErrorView(title: title,
                      message: message,
                      image: image,
                      refreshButtonTitle: "Обновить",
                      buttonAction: buttonAction)
    }

    func showErrorView(title: String, message: String, buttonAction: CompletionBlock?) {
        showErrorView(title: title,
                      message: message,
                      image: UIImage(named: "unexpectedError"),
                      buttonAction: buttonAction)
    }

    func showErrorView(isUnexpectedError: Bool, buttonAction: CompletionBlock?) {
        let title = isUnexpectedError ? "Неизвестная ошибка" : "Отсутствует интернет"
        let message = (isUnexpectedError ?
                        "Произошла неизветная ошибка, попробуйте перезагрузить приложение" :
                        "Проверьте сеть и перезагрузите экран")
        let image: UIImage? = (isUnexpectedError ?
                               UIImage(named: "unexpectedError") :
                                UIImage(named: "noInternetConnection"))
        showErrorView(title: title,
                      message: message,
                      image: image,
                      refreshButtonTitle: "Обновить",
                      buttonAction: buttonAction)
    }
}
