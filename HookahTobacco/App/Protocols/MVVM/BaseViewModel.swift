//
//  BaseViewModel.swift
//  HookahTobacco
//
//  Created by Антон Кочетков on 08.07.2024.
//

import Foundation
import HookahTobaccoCore

struct AlertState {
    let title: String
    let message: String
    let actions: [Action]
    
    struct Action {
        let title: String
        let action: VoidBlock?
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
    
    func changeIsLoading(newValue: Bool) async {
        await MainActor.run {
            isLoading = newValue
        }
    }
    
    func networkRequest(
        closure: @escaping (() async throws -> Void),
        errorClosure: @escaping (DomainError) async -> Void
    ) {
        Task {
            await self.changeIsLoading(newValue: true)
            do {
                try await closure()
                await self.changeIsLoading(newValue: false)
            } catch let error as DomainError {
                await self.changeIsLoading(newValue: false)
                await errorClosure(error)
            }
        }
    }
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
        buttonAction: VoidBlock?
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
        buttonAction: VoidBlock?
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
        buttonAction: VoidBlock?
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
