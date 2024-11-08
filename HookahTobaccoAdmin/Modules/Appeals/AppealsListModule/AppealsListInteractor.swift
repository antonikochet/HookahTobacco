//
//
//  AppealsListInteractor.swift
//  HookahTobaccoAdmin
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import Foundation
import HookahTobaccoCore
import HookahTobaccoCoreAdmin

protocol AppealsListInteractorInputProtocol: AnyObject {
    func startingLoadingData()
    func receiveThemes()
    func receiveAppealForEdit(by index: Int)
    func receiveNextPage()
    func receiveAppeal(with themes: [ThemeAppeal], status: AppealStatus?)
}

protocol AppealsListInteractorOutputProtocol: PresenterrProtocol {
    func receivedAppeals(_ appeals: [AppealEntity])
    func receivedThemes(_ themes: [ThemeAppeal])
    func receivedAppeal(_ appeal: AppealEntity)
}

class AppealsListInteractor {
    // MARK: - Public properties
    weak var presenter: AppealsListInteractorOutputProtocol!

    // MARK: - Dependency
    private let appealsRepo: AppealsRepoProtocol
    private let adminAppealsRepo: AdminAppealsRepoProtocol

    // MARK: - Private properties
    private var appeals: [AppealEntity] = []
    private var page: Int = 0
    private var status: AppealStatus?
    private var filterThemes: [ThemeAppeal] = []

    // MARK: - Initializers
    init(appealsRepo: AppealsRepoProtocol,
         adminAppealsRepo: AdminAppealsRepoProtocol) {
        self.appealsRepo = appealsRepo
        self.adminAppealsRepo = adminAppealsRepo
    }

    // MARK: - Private methods
    private func receiveAppeals() {
        guard page != -1 else { return }
        adminAppealsRepo.fetchAppeals(page: page,
                                      status: status,
                                      themes: filterThemes
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.page = response.next ?? -1
                self.appeals.append(contentsOf: response.results)
                self.presenter.receivedAppeals(self.appeals)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }

    private func receiveTheme() {
        appealsRepo.fetchThemes { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let response):
                self.presenter.receivedThemes(response.themes)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension AppealsListInteractor: AppealsListInteractorInputProtocol {
    func startingLoadingData() {
        page = 1
        appeals = []
        receiveAppeals()
    }

    func receiveThemes() {
        receiveTheme()
    }

    func receiveAppealForEdit(by index: Int) {
        guard index < appeals.count else { return }
        let appeal = appeals[index]
        presenter.receivedAppeal(appeal)
    }

    func receiveNextPage() {
        receiveAppeals()
    }

    func receiveAppeal(with themes: [ThemeAppeal], status: AppealStatus?) {
        filterThemes = themes
        self.status = status
        page = 1
        appeals = []
        receiveAppeals()
    }
}
