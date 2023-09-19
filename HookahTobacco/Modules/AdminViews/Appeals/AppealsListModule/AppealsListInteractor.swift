//
//
//  AppealsListInteractor.swift
//  HookahTobacco
//
//  Created by Anton Kochetkov on 19.09.2023.
//
//

import Foundation

protocol AppealsListInteractorInputProtocol: AnyObject {
    func startingLoadingData()
    func receiveAppealForEdit(by index: Int)
}

protocol AppealsListInteractorOutputProtocol: PresenterrProtocol {
    func receivedAppeals(_ appeals: [AppealResponse])
    func receivedAppeal(_ appeal: AppealResponse)
}

class AppealsListInteractor {
    // MARK: - Public properties
    weak var presenter: AppealsListInteractorOutputProtocol!

    // MARK: - Dependency
    private let adminNetworkingService: AdminNetworkingServiceProtocol

    // MARK: - Private properties
    private var appeals: [AppealResponse] = []

    // MARK: - Initializers
    init(adminNetworkingService: AdminNetworkingServiceProtocol) {
        self.adminNetworkingService = adminNetworkingService
    }

    // MARK: - Private methods
    private func receiveAppeals() {
        adminNetworkingService.receiveAppeals { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let appeals):
                self.appeals = appeals
                self.presenter.receivedAppeals(appeals)
            case .failure(let error):
                self.presenter.receivedError(error)
            }
        }
    }
}
// MARK: - InputProtocol implementation 
extension AppealsListInteractor: AppealsListInteractorInputProtocol {
    func startingLoadingData() {
        receiveAppeals()
    }

    func receiveAppealForEdit(by index: Int) {
        guard index < appeals.count else { return }
        let appeal = appeals[index]
        presenter.receivedAppeal(appeal)
    }
}
