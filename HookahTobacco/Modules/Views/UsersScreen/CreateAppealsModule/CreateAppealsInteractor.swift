//
//
//  CreateAppealsInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 17.09.2023.
//
//

import Foundation

protocol CreateAppealsInteractorInputProtocol: AnyObject {
    func receiveStaringData()
    func receiveSelectTheme() -> ThemeAppeal?
    func updateSelectedTheme(_ index: Int)
    func sendAppeal(_ data: CreateAppealsEntity.EnterData, contents: [URL])
}

protocol CreateAppealsInteractorOutputProtocol: PresenterrProtocol {
    func receivedStartingData(_ themes: [ThemeAppeal], _ user: ThemeAppealUser?)
    func receivedSuccessNewAppeal(_ response: CreateAppealResponse)
}

class CreateAppealsInteractor {
    // MARK: - Public properties
    weak var presenter: CreateAppealsInteractorOutputProtocol!

    // MARK: - Dependency
    private let appealsNetworkingService: AppealsNetworkingServiceProtocol

    // MARK: - Private properties
    private var themes: [ThemeAppeal] = []
    private var userId: Int?
    private var selectedThemes: ThemeAppeal?

    // MARK: - Initializers
    init(appealsNetworkingService: AppealsNetworkingServiceProtocol) {
        self.appealsNetworkingService = appealsNetworkingService
    }

    // MARK: - Private methods
    private func receiveThemes() {
        appealsNetworkingService.receiveThemes { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.themes = response.themes
                self.userId = response.user?.id
                self.presenter.receivedStartingData(response.themes, response.user)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func sendNewAppeals(_ appeal: CreateAppealEntity) {
        appealsNetworkingService.createAppeal(appeal) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.presenter.receivedSuccessNewAppeal(response)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension CreateAppealsInteractor: CreateAppealsInteractorInputProtocol {
    func receiveStaringData() {
        receiveThemes()
    }

    func receiveSelectTheme() -> ThemeAppeal? {
        selectedThemes
    }

    func updateSelectedTheme(_ index: Int) {
        selectedThemes = themes[index]
    }

    func sendAppeal(_ data: CreateAppealsEntity.EnterData, contents: [URL]) {
        guard let selectedThemes else { return }
        let appeal = CreateAppealEntity(name: data.name,
                                        email: data.email,
                                        user: userId,
                                        theme: selectedThemes.id,
                                        message: data.message,
                                        contents: contents)
        sendNewAppeals(appeal)
    }
}
