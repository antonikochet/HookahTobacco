//
//  BaseViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 08.07.2024.
//

import Foundation

struct AlertState {
    let title: String
    let message: String
    let actions: [Action]
    
    struct Action {
        let title: String
        let action: CompletionBlock?
    }
}

protocol BaseViewModel: ObservableObject {
    var isLoading: Bool { get set }
    var hasAlert: Bool { get set }
    var alertState: AlertState { get }
    var infoView: InfoViewModel? { get }
}

class BaseViewModelImpl: BaseViewModel {
    @Published var isLoading: Bool = false
    @Published var hasAlert: Bool = false
    @Published var alertState: AlertState = AlertState(title: "", message: "", actions: [])
    
    @Published var infoView: InfoViewModel?
}

// MARK: - Alerts
extension BaseViewModelImpl {
    func showAlert(
        title: String,
        message: String,
        actions: [AlertState.Action]
    ) {
        alertState = AlertState(
            title: title,
            message: message,
            actions: actions
        )
        hasAlert = true
    }
    
    func showAlertError(message: String) {
        showAlert(
            title: "Ошибка",
            message: message,
            actions: [AlertState.Action(title: "Ok", action: nil)]
        )
    }
}

// MARK: - InfoView
extension BaseViewModelImpl {
    func showErrorView(
        title: String,
        message: String,
        buttonAction: CompletionBlock?
    ) {
        showErrorView(
            title: title,
            message: message,
            image: "unexpectedError",
            refreshButtonTitle: "Обновить",
            buttonAction: buttonAction
        )
    }
    
    func showErrorView(
        isUnexpectedError: Bool,
        buttonAction: CompletionBlock?
    ) {
        let title = isUnexpectedError ? "Неизвестная ошибка" : "Отсутствует интернет"
        let message = (
            isUnexpectedError ?
            "Произошла неизветная ошибка, попробуйте перезагрузить приложение" :
            "Проверьте сеть и перезагрузите экран"
        )
        let image: String = isUnexpectedError ? "unexpectedError" : "noInternetConnection"
        showErrorView(
            title: title,
            message: message,
            image: image,
            refreshButtonTitle: "Обновить",
            buttonAction: buttonAction
        )
    }
    
    func showErrorView(
        title: String,
        message: String,
        image: String?,
        refreshButtonTitle: String,
        buttonAction: CompletionBlock?
    ) {
        var primaryAction: ActionWithTitle?
        if buttonAction != nil {
            primaryAction = ActionWithTitle(title: refreshButtonTitle) {
                buttonAction?()
            }
        }
        showInfoView(
            title: title,
            message: message,
            image: image,
            primaryAction: primaryAction
        )
    }
    
    func showInfoView(
        title: String,
        message: String,
        image: String?,
        primaryAction: ActionWithTitle?,
        secondaryAction: ActionWithTitle? = nil
    ) {
        let viewModel = InfoViewModel(
            image: image,
            title: title,
            subtitle: message,
            primaryAction: primaryAction,
            secondaryAction: secondaryAction
        )
        infoView = viewModel
    }
}
