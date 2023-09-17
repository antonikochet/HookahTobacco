//
//
//  CreateAppealsPresenter.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import Foundation

class CreateAppealsPresenter {
    // MARK: - Public properties
    weak var view: CreateAppealsViewInputProtocol!
    var interactor: CreateAppealsInteractorInputProtocol!
    var router: CreateAppealsRouterProtocol!

    // MARK: - Private properties
    private var themes: [ThemeAppeal] = []

    // MARK: - Private methods

}

// MARK: - InteractorOutputProtocol implementation
extension CreateAppealsPresenter: CreateAppealsInteractorOutputProtocol {
    func receivedStartingData(_ themes: [ThemeAppeal], _ user: ThemeAppealUser?) {
        view.hideLoading()
        self.themes = themes
        view.setupView(CreateAppealsEntity.ViewModel(name: user?.name ?? "",
                                                     email: user?.email ?? ""))
        view.setupThemeView(.notSelectThemeText)
    }

    func receivedSuccessNewAppeal(_ response: CreateAppealResponse) {
        view.hideLoading()
        router.popView(response)
    }

    func receivedError(_ error: HTError) {
        view.hideLoading()
        if case .apiError(let apiErrors) = error {
            for apiError in apiErrors {
                if apiError.fieldName == CreateAppealEntity.CodingKeys.name.rawValue {
                    view.showError(apiError.message, field: .name)
                } else if apiError.fieldName == CreateAppealEntity.CodingKeys.email.rawValue {
                    view.showError(apiError.message, field: .email)
                } else if apiError.fieldName == CreateAppealEntity.CodingKeys.theme.rawValue {
                    view.showError(apiError.message, field: .theme)
                } else if apiError.fieldName == CreateAppealEntity.CodingKeys.message.rawValue {
                    view.showError(apiError.message, field: .message)
                } else {
                    router.showError(with: apiError.message)
                }
            }
        } else {
            router.showError(with: error.message)
        }
    }
}

// MARK: - ViewOutputProtocol implementation
extension CreateAppealsPresenter: CreateAppealsViewOutputProtocol {
    func viewDidLoad() {
        view.showBlockLoading()
        interactor.receiveStaringData()
    }

    func pressedThemeView() {
        let selectedTheme = interactor.receiveSelectTheme()
        let index = themes.firstIndex(where: { $0.id == selectedTheme?.id })
        let items = themes.map { $0.name }
        router.showSelectTheme(title: R.string.localizable.createAppealsSelectThemeBottomSheetTitle(),
                               items: items,
                               selectedIndex: index,
                               output: self)
    }

    func pressedSendButton(_ enterData: CreateAppealsEntity.EnterData) {
        var hasError = false
        if enterData.name.isEmpty {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .name)
            hasError = true
        }
        if enterData.email.isEmpty {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .email)
            hasError = true
        } else if !enterData.email.isEmailValid() {
            view.showError(R.string.localizable.createAppealsEmailNotValidMessage(), field: .email)
            hasError = true
        }
        if enterData.message.isEmpty {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .message)
            hasError = true
        }
        if interactor.receiveSelectTheme() == nil {
            view.showError(R.string.localizable.createAppealsTextFieldEmptyErrorMessage(), field: .theme)
            hasError = true
        }

        if hasError {
            return
        }

        view.showBlockLoading()
        interactor.sendAppeal(enterData)
    }
}

// MARK: - SelectListBottomSheetOutputModule implementation
extension CreateAppealsPresenter: SelectListBottomSheetOutputModule {
    func receiveNewData(_ newIndex: Int?) {
        if let newIndex {
            interactor.updateSelectedTheme(newIndex)
            let theme = themes[newIndex]
            view.setupThemeView(theme.name)
        } else {
            view.setupThemeView(.notSelectThemeText)
        }
    }
}

private extension String {
    static let notSelectThemeText = R.string.localizable.createAppealsThemeSelect()
}
